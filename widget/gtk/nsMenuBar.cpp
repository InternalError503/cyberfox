/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/DebugOnly.h"
#include "mozilla/dom/Element.h"
#include "mozilla/Preferences.h"
#include "nsAutoPtr.h"
#include "nsIDocument.h"
#include "nsIDOMEvent.h"
#include "nsIDOMEventListener.h"
#include "nsIDOMEventTarget.h"
#include "nsIDOMKeyEvent.h"
#include "nsIWidget.h"
#include "nsTArray.h"
#include "nsUnicharUtils.h"

#include "nsMenu.h"
#include "nsNativeMenuAtoms.h"
#include "nsNativeMenuService.h"

#include <gdk/gdk.h>
#include <gdk/gdkx.h>
#include <glib.h>
#include <glib-object.h>

#include "nsMenuBar.h"

using namespace mozilla;

class nsMenuBarDocEventListener final : public nsIDOMEventListener
{
public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIDOMEVENTLISTENER

    nsMenuBarDocEventListener(nsMenuBar *aOwner) : mOwner(aOwner) { };

private:
    ~nsMenuBarDocEventListener() { };

    nsMenuBar *mOwner;
};

NS_IMPL_ISUPPORTS(nsMenuBarDocEventListener, nsIDOMEventListener)

NS_IMETHODIMP
nsMenuBarDocEventListener::HandleEvent(nsIDOMEvent *aEvent)
{
    nsAutoString type;
    nsresult rv = aEvent->GetType(type);
    if (NS_FAILED(rv)) {
        NS_WARNING("Failed to determine event type");
        return rv;
    }

    if (type.Equals(NS_LITERAL_STRING("focus"))) {
        mOwner->Focus();
    } else if (type.Equals(NS_LITERAL_STRING("blur"))) {
        mOwner->Blur();
    } else if (type.Equals(NS_LITERAL_STRING("keypress"))) {
        rv = mOwner->Keypress(aEvent);
    } else if (type.Equals(NS_LITERAL_STRING("keydown"))) {
        rv = mOwner->KeyDown(aEvent);
    } else if (type.Equals(NS_LITERAL_STRING("keyup"))) {
        rv = mOwner->KeyUp(aEvent);
    }

    return rv;
}

void
nsMenuBar::Build()
{
    uint32_t count = ContentNode()->GetChildCount();
    for (uint32_t i = 0; i < count; ++i) {
        nsIContent *childContent = ContentNode()->GetChildAt(i);

        nsresult rv;
        nsMenuObject *child = CreateChild(childContent, &rv);

        if (child) {
            rv = AppendChild(child);
        }

        if (NS_FAILED(rv)) {
            NS_ERROR("Failed to build menubar");
            return;
        }
    }
}

void
nsMenuBar::DisconnectDocumentEventListeners()
{
    mDocument->RemoveEventListener(NS_LITERAL_STRING("focus"),
                                   mEventListener,
                                   true);
    mDocument->RemoveEventListener(NS_LITERAL_STRING("blur"),
                                   mEventListener,
                                   true);
    mDocument->RemoveEventListener(NS_LITERAL_STRING("keypress"),
                                   mEventListener,
                                   false);
    mDocument->RemoveEventListener(NS_LITERAL_STRING("keydown"),
                                   mEventListener,
                                   false);
    mDocument->RemoveEventListener(NS_LITERAL_STRING("keyup"),
                                   mEventListener,
                                   false);
}

void
nsMenuBar::SetShellShowingMenuBar(bool aShowing)
{
    ContentNode()->OwnerDoc()->GetRootElement()->SetAttr(
        kNameSpaceID_None, nsNativeMenuAtoms::shellshowingmenubar,
        aShowing ? NS_LITERAL_STRING("true") : NS_LITERAL_STRING("false"),
        true);
}

void
nsMenuBar::Focus()
{
    ContentNode()->SetAttr(kNameSpaceID_None, nsNativeMenuAtoms::openedwithkey,
                           NS_LITERAL_STRING("false"), true);
}

void
nsMenuBar::Blur()
{
    // We do this here in case we lose focus before getting the
    // keyup event, which leaves the menubar state looking like
    // the alt key is stuck down
    dbusmenu_server_set_status(mServer, DBUSMENU_STATUS_NORMAL);
}

static bool
ShouldHandleKeyEvent(nsIDOMEvent *aEvent)
{
    bool handled, trusted = false;
    aEvent->GetPreventDefault(&handled);
    aEvent->GetIsTrusted(&trusted);

    if (handled || !trusted) {
        return false;
    }

    return true;
}

nsMenuBar::ModifierFlags
nsMenuBar::GetModifiersFromEvent(nsIDOMKeyEvent *aEvent)
{
    ModifierFlags modifiers = static_cast<ModifierFlags>(0);
    bool modifier;

    aEvent->GetAltKey(&modifier);
    if (modifier) {
        modifiers = static_cast<ModifierFlags>(modifiers | eModifierAlt);
    }

    aEvent->GetShiftKey(&modifier);
    if (modifier) {
        modifiers = static_cast<ModifierFlags>(modifiers | eModifierShift);
    }

    aEvent->GetCtrlKey(&modifier);
    if (modifier) {
        modifiers = static_cast<ModifierFlags>(modifiers | eModifierCtrl);
    }

    aEvent->GetMetaKey(&modifier);
    if (modifier) {
        modifiers = static_cast<ModifierFlags>(modifiers | eModifierMeta);
    }

    return modifiers;
}

nsresult
nsMenuBar::Keypress(nsIDOMEvent *aEvent)
{
    if (!ShouldHandleKeyEvent(aEvent)) {
        return NS_OK;
    }

    nsCOMPtr<nsIDOMKeyEvent> keyEvent = do_QueryInterface(aEvent);
    if (!keyEvent) {
        return NS_OK;
    }

    ModifierFlags modifiers = GetModifiersFromEvent(keyEvent);
    if (((modifiers & mAccessKeyMask) == 0) ||
        ((modifiers & ~mAccessKeyMask) != 0)) {
        return NS_OK;
    }

    uint32_t charCode;
    keyEvent->GetCharCode(&charCode);
    if (charCode == 0) {
        return NS_OK;
    }

    char16_t ch = char16_t(charCode);
    char16_t chl = ToLowerCase(ch);
    char16_t chu = ToUpperCase(ch);

    nsMenuObject *found = nullptr;
    uint32_t count = ChildCount();
    for (uint32_t i = 0; i < count; ++i) {
        nsAutoString accesskey;
        ChildAt(i)->ContentNode()->GetAttr(kNameSpaceID_None,
                                           nsGkAtoms::accesskey,
                                           accesskey);
        const nsAutoString::char_type *key = accesskey.BeginReading();
        if (*key == chu || *key == chl) {
            found = ChildAt(i);
            break;
        }
    }

    if (!found || found->Type() != nsMenuObject::eType_Menu) {
        return NS_OK;
    }

    ContentNode()->SetAttr(kNameSpaceID_None, nsNativeMenuAtoms::openedwithkey,
                           NS_LITERAL_STRING("true"), true);
    static_cast<nsMenu *>(found)->OpenMenu();

    aEvent->StopPropagation();
    aEvent->PreventDefault();

    return NS_OK;
}

nsresult
nsMenuBar::KeyDown(nsIDOMEvent *aEvent)
{
    if (!ShouldHandleKeyEvent(aEvent)) {
        return NS_OK;
    }

    nsCOMPtr<nsIDOMKeyEvent> keyEvent = do_QueryInterface(aEvent);
    if (!keyEvent) {
        return NS_OK;
    }

    uint32_t keyCode;
    keyEvent->GetKeyCode(&keyCode);
    ModifierFlags modifiers = GetModifiersFromEvent(keyEvent);
    if ((keyCode != mAccessKey) || ((modifiers & ~mAccessKeyMask) != 0)) {
        return NS_OK;
    }

    dbusmenu_server_set_status(mServer, DBUSMENU_STATUS_NOTICE);

    return NS_OK;
}

nsresult
nsMenuBar::KeyUp(nsIDOMEvent *aEvent)
{
    if (!ShouldHandleKeyEvent(aEvent)) {
        return NS_OK;
    }

    nsCOMPtr<nsIDOMKeyEvent> keyEvent = do_QueryInterface(aEvent);
    if (!keyEvent) {
        return NS_OK;
    }

    uint32_t keyCode;
    keyEvent->GetKeyCode(&keyCode);
    if (keyCode == mAccessKey) {
        dbusmenu_server_set_status(mServer, DBUSMENU_STATUS_NORMAL);
    }

    return NS_OK;
}

nsMenuBar::nsMenuBar() :
    nsMenuContainer(),
    mTopLevel(nullptr),
    mServer(nullptr),
    mIsActive(false)
{
    MOZ_COUNT_CTOR(nsMenuBar);
}

nsresult
nsMenuBar::Init(nsIWidget *aParent, nsIContent *aMenuBarNode)
{
    NS_ENSURE_ARG(aParent);
    NS_ENSURE_ARG(aMenuBarNode);

    GdkWindow *gdkWin = static_cast<GdkWindow *>(
        aParent->GetNativeData(NS_NATIVE_WINDOW));
    if (!gdkWin) {
        return NS_ERROR_FAILURE;
    }

    gpointer user_data = nullptr;
    gdk_window_get_user_data(gdkWin, &user_data);
    if (!user_data || !GTK_IS_CONTAINER(user_data)) {
        return NS_ERROR_FAILURE;
    }

    mTopLevel = gtk_widget_get_toplevel(GTK_WIDGET(user_data));
    if (!mTopLevel) {
        return NS_ERROR_FAILURE;
    }

    g_object_ref(mTopLevel);

    RefPtr<nsNativeMenuDocListener> listener =
        nsNativeMenuDocListener::Create(aMenuBarNode);
    if (!listener) {
        return NS_ERROR_FAILURE;
    }

    nsMenuObject::Init(listener, aMenuBarNode);

    nsAutoCString path;
    path.Append(NS_LITERAL_CSTRING("/com/canonical/menu/"));
    char xid[10];
    sprintf(xid, "%X", static_cast<uint32_t>(
        GDK_WINDOW_XID(gtk_widget_get_window(mTopLevel))));
    path.Append(xid);

    mServer = dbusmenu_server_new(path.get());
    if (!mServer) {
        return NS_ERROR_FAILURE;
    }

    CreateNativeData();
    if (!GetNativeData()) {
        return NS_ERROR_FAILURE;
    }

    dbusmenu_server_set_root(mServer, GetNativeData());

    mEventListener = new nsMenuBarDocEventListener(this);

    mDocument = do_QueryInterface(ContentNode()->OwnerDoc());

    mAccessKey = Preferences::GetInt("ui.key.menuAccessKey");
    if (mAccessKey == nsIDOMKeyEvent::DOM_VK_SHIFT) {
        mAccessKeyMask = eModifierShift;
    } else if (mAccessKey == nsIDOMKeyEvent::DOM_VK_CONTROL) {
        mAccessKeyMask = eModifierCtrl;
    } else if (mAccessKey == nsIDOMKeyEvent::DOM_VK_ALT) {
        mAccessKeyMask = eModifierAlt;
    } else if (mAccessKey == nsIDOMKeyEvent::DOM_VK_META) {
        mAccessKeyMask = eModifierMeta;
    } else {
        mAccessKeyMask = eModifierAlt;
    }

    return NS_OK;
}

nsMenuBar::~nsMenuBar()
{
    nsNativeMenuService *service = nsNativeMenuService::GetSingleton();
    if (service) {
        service->NotifyNativeMenuBarDestroyed(this);
    }

    if (ContentNode()) {
        SetShellShowingMenuBar(false);
    }

    // We want to destroy all children before dropping our reference
    // to the doc listener
    while (ChildCount() > 0) {
        RemoveChildAt(0);
    }

    if (mTopLevel) {
        g_object_unref(mTopLevel);
    }

    if (DocListener()) {
        DocListener()->Stop();
    }

    if (mDocument) {
        DisconnectDocumentEventListeners();
    }

    if (mServer) {
        g_object_unref(mServer);
    }

    MOZ_COUNT_DTOR(nsMenuBar);
}

/* static */ nsMenuBar*
nsMenuBar::Create(nsIWidget *aParent, nsIContent *aMenuBarNode)
{
    nsAutoPtr<nsMenuBar> menubar(new nsMenuBar());
    if (NS_FAILED(menubar->Init(aParent, aMenuBarNode))) {
        return nullptr;
    }

    return menubar.forget();
}

nsMenuObject::EType
nsMenuBar::Type() const
{
    return nsMenuObject::eType_MenuBar;
}

bool
nsMenuBar::IsBeingDisplayed() const
{
    return true;
}

uint32_t
nsMenuBar::WindowId() const
{
    return static_cast<uint32_t>(GDK_WINDOW_XID(gtk_widget_get_window(mTopLevel)));
}

nsAdoptingCString
nsMenuBar::ObjectPath() const
{
    gchar *tmp;
    g_object_get(mServer, DBUSMENU_SERVER_PROP_DBUS_OBJECT, &tmp, NULL);
    nsAdoptingCString result(tmp);

    return result;
}

nsNativeMenuGIORequest&
nsMenuBar::BeginRegisterRequest()
{
    mRegisterRequestCanceller.Start();
    return mRegisterRequestCanceller;
}

void
nsMenuBar::EndRegisterRequest()
{
    NS_ASSERTION(RegisterRequestInProgress(), "No request in progress");
    mRegisterRequestCanceller.Finish();
}

bool
nsMenuBar::RegisterRequestInProgress() const
{
    return mRegisterRequestCanceller.InProgress();
}

void
nsMenuBar::Activate()
{
    if (mIsActive) {
        return;
    }

    mIsActive = true;

    mDocument->AddEventListener(NS_LITERAL_STRING("focus"),
                                mEventListener,
                                true);
    mDocument->AddEventListener(NS_LITERAL_STRING("blur"),
                                mEventListener,
                                true);
    mDocument->AddEventListener(NS_LITERAL_STRING("keypress"),
                                mEventListener,
                                false);
    mDocument->AddEventListener(NS_LITERAL_STRING("keydown"),
                                mEventListener,
                                false);
    mDocument->AddEventListener(NS_LITERAL_STRING("keyup"),
                                mEventListener,
                                false);

    // Clear this. Not sure if we really need to though
    ContentNode()->SetAttr(kNameSpaceID_None, nsNativeMenuAtoms::openedwithkey,
                           NS_LITERAL_STRING("false"), true);

    DocListener()->Start();
    Build();
    SetShellShowingMenuBar(true);
}

void
nsMenuBar::Deactivate()
{
    if (!mIsActive) {
        return;
    }

    mIsActive = false;

    mRegisterRequestCanceller.Cancel();

    SetShellShowingMenuBar(false);
    while (ChildCount() > 0) {
        RemoveChildAt(0);
    }
    DocListener()->Stop();
    DisconnectDocumentEventListeners();
}

void
nsMenuBar::OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute)
{

}

void
nsMenuBar::OnContentInserted(nsIContent *aContainer, nsIContent *aChild,
                             nsIContent *aPrevSibling)
{
    NS_ASSERTION(aContainer == ContentNode(),
                 "Received an event that wasn't meant for us");

    nsresult rv;
    nsMenuObject *child = CreateChild(aChild, &rv);

    if (child) {
        rv = InsertChildAfter(child, aPrevSibling);
    }

    NS_ASSERTION(NS_SUCCEEDED(rv), "Failed to insert item in to menubar");
}

void
nsMenuBar::OnContentRemoved(nsIContent *aContainer, nsIContent *aChild)
{
    NS_ASSERTION(aContainer == ContentNode(),
                 "Received an event that wasn't meant for us");

    DebugOnly<nsresult> rv = RemoveChild(aChild);
    NS_ASSERTION(NS_SUCCEEDED(rv), "Failed to remove item from menubar");
}
