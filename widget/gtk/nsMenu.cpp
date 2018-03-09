/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#define _IMPL_NS_LAYOUT

#include "mozilla/GuardObjects.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/StyleSetHandleInlines.h"
#include "nsAutoPtr.h"
#include "nsBindingManager.h"
#include "nsComponentManagerUtils.h"
#include "nsContentUtils.h"
#include "nsCSSValue.h"
#include "nsGkAtoms.h"
#include "nsGtkUtils.h"
#include "nsIAtom.h"
#include "nsIContent.h"
#include "nsIDocument.h"
#include "nsIPresShell.h"
#include "nsIRunnable.h"
#include "nsITimer.h"
#include "nsString.h"
#include "nsStyleContext.h"
#include "nsStyleSet.h"
#include "nsStyleStruct.h"
#include "nsThreadUtils.h"
#include "nsXBLBinding.h"
#include "nsXBLService.h"

#include "nsNativeMenuAtoms.h"
#include "nsNativeMenuDocListener.h"

#include <glib-object.h>

#include "nsMenu.h"

using namespace mozilla;

class MOZ_STACK_CLASS nsMenuUpdateBatch
{
public:
    nsMenuUpdateBatch(nsMenu *aMenu MOZ_GUARD_OBJECT_NOTIFIER_PARAM) :
        mMenu(aMenu)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        mMenu->BeginUpdateBatchInternal();
    }

    ~nsMenuUpdateBatch()
    {
        mMenu->EndUpdateBatch();
    }

private:
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
    nsMenu *mMenu;
};

class nsSetAttrRunnableNoNotify : public Runnable
{
public:
    nsSetAttrRunnableNoNotify(nsIContent *aContent, nsIAtom *aAttribute,
                              nsAString& aValue) :
        mContent(aContent), mAttribute(aAttribute), mValue(aValue) { };

    NS_IMETHODIMP Run()
    {
        return mContent->SetAttr(kNameSpaceID_None, mAttribute, mValue, false);
    }

private:
    nsCOMPtr<nsIContent> mContent;
    nsCOMPtr<nsIAtom> mAttribute;
    nsAutoString mValue;
};

class nsUnsetAttrRunnableNoNotify : public Runnable
{
public:
    nsUnsetAttrRunnableNoNotify(nsIContent *aContent, nsIAtom *aAttribute) :
        mContent(aContent), mAttribute(aAttribute) { };

    NS_IMETHODIMP Run()
    {
        return mContent->UnsetAttr(kNameSpaceID_None, mAttribute, false);
    }

private:
    nsCOMPtr<nsIContent> mContent;
    nsCOMPtr<nsIAtom> mAttribute;
};

static void
AttachXBLBindings(nsIContent *aContent)
{
    nsIDocument *doc = aContent->OwnerDoc();
    nsIPresShell *shell = doc->GetShell();
    if (!shell) {
        return;
    }

    RefPtr<nsStyleContext> sc =
        shell->StyleSet()->ResolveStyleFor(aContent->AsElement(),
                                           nullptr);
    if (!sc) {
        return;
    }

    const nsStyleDisplay* display = sc->StyleDisplay();
    if (!display->mBinding) {
        return;
    }

    nsXBLService* xbl = nsXBLService::GetInstance();
    if (!xbl) {
        return;
    }

    RefPtr<nsXBLBinding> binding;
    bool dummy;
    nsresult rv = xbl->LoadBindings(aContent, display->mBinding->GetURI(),
                                    display->mBinding->mOriginPrincipal,
                                    getter_AddRefs(binding), &dummy);
    if ((NS_FAILED(rv) && rv != NS_ERROR_XBL_BLOCKED) || !binding) {
        return;
    }

    doc->BindingManager()->AddToAttachedQueue(binding);
}

void
nsMenu::SetPopupState(EPopupState aState)
{
    ClearFlags(((1U << NSMENU_NUMBER_OF_POPUPSTATE_BITS) - 1U) << NSMENU_NUMBER_OF_FLAGS);
    SetFlags(aState << NSMENU_NUMBER_OF_FLAGS);

    if (!mPopupContent) {
        return;
    }

    nsAutoString state;
    switch (aState) {
        case ePopupState_Showing:
            state.Assign(NS_LITERAL_STRING("showing"));
            break;
        case ePopupState_Open:
            state.Assign(NS_LITERAL_STRING("open"));
            break;
        case ePopupState_Hiding:
            state.Assign(NS_LITERAL_STRING("hiding"));
            break;
        default:
            break;
    }

    if (nsContentUtils::IsSafeToRunScript()) {
        if (state.IsEmpty()) {
            mPopupContent->UnsetAttr(kNameSpaceID_None,
                                     nsNativeMenuAtoms::_moz_menupopupstate,
                                     false);
        } else {
            mPopupContent->SetAttr(kNameSpaceID_None,
                                   nsNativeMenuAtoms::_moz_menupopupstate,
                                   state, false);
        }
    } else {
        nsCOMPtr<nsIRunnable> r;
        if (state.IsEmpty()) {
            r = new nsUnsetAttrRunnableNoNotify(
                        mPopupContent, nsNativeMenuAtoms::_moz_menupopupstate);
        } else {
            r = new nsSetAttrRunnableNoNotify(
                        mPopupContent, nsNativeMenuAtoms::_moz_menupopupstate,
                        state);
        }
        nsContentUtils::AddScriptRunner(r);
    }
}

/* static */ void
nsMenu::menu_event_cb(DbusmenuMenuitem *menu,
                      const gchar *name,
                      GVariant *value,
                      guint timestamp,
                      gpointer user_data)
{
    nsMenu *self = static_cast<nsMenu *>(user_data);

    nsAutoCString event(name);

    if (event.Equals(NS_LITERAL_CSTRING("closed"))) {
        self->OnClose();
        return;
    }

    if (event.Equals(NS_LITERAL_CSTRING("opened"))) {
        self->OnOpen();
        return;
    }
}

void
nsMenu::MaybeAddPlaceholderItem()
{
    NS_ASSERTION(!IsInUpdateBatch(),
                 "Shouldn't be modifying the native menu structure now");

    GList *children = dbusmenu_menuitem_get_children(GetNativeData());
    if (!children) {
        NS_ASSERTION(!HasPlaceholderItem(), "Huh?");

        DbusmenuMenuitem *ph = dbusmenu_menuitem_new();
        if (!ph) {
            return;
        }

        dbusmenu_menuitem_property_set_bool(
            ph, DBUSMENU_MENUITEM_PROP_VISIBLE, false);

        if (!dbusmenu_menuitem_child_append(GetNativeData(), ph)) {
            NS_WARNING("Failed to create placeholder item");
            g_object_unref(ph);
            return;
        }

        g_object_unref(ph);

        SetHasPlaceholderItem(true);
    }
}

bool
nsMenu::EnsureNoPlaceholderItem()
{
    NS_ASSERTION(!IsInUpdateBatch(),
                 "Shouldn't be modifying the native menu structure now");

    if (HasPlaceholderItem()) {
        GList *children = dbusmenu_menuitem_get_children(GetNativeData());

        NS_ASSERTION(g_list_length(children) == 1,
                     "Unexpected number of children in native menu (should be 1!)");

        SetHasPlaceholderItem(false);

        if (!children) {
            return true;
        }

        if (!dbusmenu_menuitem_child_delete(
                GetNativeData(), static_cast<DbusmenuMenuitem *>(children->data))) {
            NS_ERROR("Failed to remove placeholder item");
            return false;
        }
    }

    return true;
}

static void
DispatchMouseEvent(nsIContent *aTarget, mozilla::EventMessage aMsg)
{
    if (!aTarget) {
        return;
    }

    WidgetMouseEvent event(true, aMsg, nullptr, WidgetMouseEvent::eReal);
    aTarget->DispatchDOMEvent(&event, nullptr, nullptr, nullptr);
}

void
nsMenu::OnOpen()
{
    if (NeedsRebuild()) {
        Build();
    }

    nsWeakMenuObject<nsMenu> self(this);
    nsCOMPtr<nsIContent> origPopupContent(mPopupContent);
    {
        nsNativeMenuAutoUpdateBatch batch;

        SetPopupState(ePopupState_Showing);
        DispatchMouseEvent(mPopupContent, eXULPopupShowing);

        ContentNode()->SetAttr(kNameSpaceID_None, nsGkAtoms::open,
                               NS_LITERAL_STRING("true"), true);
    }

    if (!self) {
        // We were deleted!
        return;
    }

    // I guess that the popup could have changed
    if (origPopupContent != mPopupContent) {
        return;
    }

    nsNativeMenuAutoUpdateBatch batch;

    size_t count = ChildCount();
    for (size_t i = 0; i < count; ++i) {
        ChildAt(i)->ContainerIsOpening();
    }

    SetPopupState(ePopupState_Open);
    DispatchMouseEvent(mPopupContent, eXULPopupShown);
}

void
nsMenu::Build()
{
    nsMenuUpdateBatch batch(this);

    SetNeedsRebuild(false);

    while (ChildCount() > 0) {
        RemoveChildAt(0);
    }

    InitializePopup();

    if (!mPopupContent) {
        return;
    }

    uint32_t count = mPopupContent->GetChildCount();
    for (uint32_t i = 0; i < count; ++i) {
        nsIContent *childContent = mPopupContent->GetChildAt(i);

        nsresult rv;
        nsMenuObject *child = CreateChild(childContent, &rv);

        if (child) {
            rv = AppendChild(child);
        }

        if (NS_FAILED(rv)) {
            NS_ERROR("Menu build failed");
            SetNeedsRebuild(true);
            return;
        }
    }
}

void
nsMenu::InitializeNativeData()
{
    // Dbusmenu provides an "about-to-show" signal, and also "opened" and
    // "closed" events. However, Unity is the only thing that sends
    // both "about-to-show" and "opened" events. Unity 2D and the HUD only
    // send "opened" events, so we ignore "about-to-show" (I don't think
    // there's any real difference between them anyway).
    // To complicate things, there are certain conditions where we don't
    // get a "closed" event, so we need to be able to handle this :/
    g_signal_connect(G_OBJECT(GetNativeData()), "event",
                     G_CALLBACK(menu_event_cb), this);

    UpdateLabel();
    UpdateSensitivity();

    SetNeedsRebuild(true);
    MaybeAddPlaceholderItem();

    AttachXBLBindings(ContentNode());
}

void
nsMenu::Update(nsStyleContext *aStyleContext)
{
    UpdateVisibility(aStyleContext);
    UpdateIcon(aStyleContext);
}

void
nsMenu::InitializePopup()
{
    nsCOMPtr<nsIContent> oldPopupContent;
    oldPopupContent.swap(mPopupContent);

    for (uint32_t i = 0; i < ContentNode()->GetChildCount(); ++i) {
        nsIContent *child = ContentNode()->GetChildAt(i);

        int32_t dummy;
        nsCOMPtr<nsIAtom> tag = child->OwnerDoc()->BindingManager()->ResolveTag(child, &dummy);
        if (tag == nsGkAtoms::menupopup) {
            mPopupContent = child;
            break;
        }
    }

    if (oldPopupContent == mPopupContent) {
        return;
    }

    // The popup has changed

    if (oldPopupContent) {
        DocListener()->UnregisterForContentChanges(oldPopupContent);
    }

    SetPopupState(ePopupState_Closed);

    if (!mPopupContent) {
        return;
    }

    AttachXBLBindings(mPopupContent);

    DocListener()->RegisterForContentChanges(mPopupContent, this);
}

void
nsMenu::BeginUpdateBatchInternal()
{
    NS_ASSERTION(!IsInUpdateBatch(), "Already in an update batch!");

    SetIsInUpdateBatch(true);
    SetDidStructureMutate(false);
}

nsresult
nsMenu::RemoveChildAt(size_t aIndex)
{
    NS_ASSERTION(IsInUpdateBatch() || !HasPlaceholderItem(),
                 "Shouldn't have a placeholder menuitem");

    SetDidStructureMutate(true);

    nsresult rv = nsMenuContainer::RemoveChildAt(aIndex, !IsInUpdateBatch());

    if (!IsInUpdateBatch()) {
        MaybeAddPlaceholderItem();
    }

    return rv;
}

nsresult
nsMenu::RemoveChild(nsIContent *aChild)
{
    size_t index = IndexOf(aChild);
    if (index == NoIndex) {
        return NS_ERROR_INVALID_ARG;
    }

    return RemoveChildAt(index);
}

nsresult
nsMenu::InsertChildAfter(nsMenuObject *aChild, nsIContent *aPrevSibling)
{
    if (!IsInUpdateBatch() && !EnsureNoPlaceholderItem()) {
        return NS_ERROR_FAILURE;
    }

    SetDidStructureMutate(true);

    return nsMenuContainer::InsertChildAfter(aChild, aPrevSibling,
                                             !IsInUpdateBatch());
}

nsresult
nsMenu::AppendChild(nsMenuObject *aChild)
{
    if (!IsInUpdateBatch() && !EnsureNoPlaceholderItem()) {
        return NS_ERROR_FAILURE;
    }

    SetDidStructureMutate(true);

    return nsMenuContainer::AppendChild(aChild, !IsInUpdateBatch());
}

bool
nsMenu::CanOpen() const
{
    bool isVisible = dbusmenu_menuitem_property_get_bool(GetNativeData(),
                                                         DBUSMENU_MENUITEM_PROP_VISIBLE);
    bool isDisabled = ContentNode()->AttrValueIs(kNameSpaceID_None,
                                                 nsGkAtoms::disabled,
                                                 nsGkAtoms::_true,
                                                 eCaseMatters);

    return (isVisible && !isDisabled);
}

nsMenuObject::PropertyFlags
nsMenu::SupportedProperties() const
{
    return static_cast<nsMenuObject::PropertyFlags>(
        nsMenuObject::ePropLabel |
        nsMenuObject::ePropEnabled |
        nsMenuObject::ePropVisible |
        nsMenuObject::ePropIconData |
        nsMenuObject::ePropChildDisplay
    );
}

nsMenu::nsMenu() :
    nsMenuContainer()
{
    MOZ_COUNT_CTOR(nsMenu);
}

nsMenu::~nsMenu()
{
    if (IsInUpdateBatch()) {
        EndUpdateBatch();
    }

    // Although nsTArray will take care of this in its destructor,
    // we have to manually ensure children are removed from our native menu
    // item, just in case our parent recycles us
    while (ChildCount() > 0) {
        RemoveChildAt(0);
    }

    EnsureNoPlaceholderItem();

    if (DocListener() && mPopupContent) {
        DocListener()->UnregisterForContentChanges(mPopupContent);
    }

    if (GetNativeData()) {
        g_signal_handlers_disconnect_by_func(GetNativeData(),
                                             FuncToGpointer(menu_event_cb),
                                             this);
    }

    MOZ_COUNT_DTOR(nsMenu);
}

/* static */ nsMenuObject*
nsMenu::Create(nsMenuContainer *aParent, nsIContent *aContent)
{
    nsAutoPtr<nsMenu> menu(new nsMenu());
    if (NS_FAILED(menu->Init(aParent, aContent))) {
        return nullptr;
    }

    return menu.forget();
}

static void
DoOpen(nsITimer *aTimer, void *aClosure)
{
    nsAutoWeakMenuObject<nsMenu> weakMenu(
        static_cast<nsWeakMenuObject<nsMenu> *>(aClosure));

    if (weakMenu) {
        dbusmenu_menuitem_show_to_user(weakMenu->GetNativeData(), 0);
    }

    NS_RELEASE(aTimer);
}

nsMenuObject::EType
nsMenu::Type() const
{
    return nsMenuObject::eType_Menu;
}

bool
nsMenu::IsBeingDisplayed() const
{
    return PopupState() == ePopupState_Open;
}

bool
nsMenu::NeedsRebuild() const
{
    return HasFlags(eFlag_NeedsRebuild);
}

void
nsMenu::OpenMenu()
{
    if (!CanOpen()) {
        return;
    }

    // Here, we synchronously fire popupshowing and popupshown events and then
    // open the menu after a short delay. This allows the menu to refresh before
    // it's shown, and avoids an issue where keyboard focus is not on the first
    // item of the history menu in Firefox when opening it with the keyboard,
    // because extra items to appear at the top of the menu

    OnOpen();

    nsCOMPtr<nsITimer> timer = do_CreateInstance(NS_TIMER_CONTRACTID);
    if (!timer) {
        return;
    }

    nsAutoWeakMenuObject<nsMenu> weakMenu(this);

    if (NS_FAILED(timer->InitWithFuncCallback(DoOpen, weakMenu.getWeakPtr(),
                                              100, nsITimer::TYPE_ONE_SHOT))) {
        return;
    }

    timer.forget();
    weakMenu.forget();
}

void
nsMenu::OnClose()
{
    if (PopupState() == ePopupState_Closed) {
        return;
    }

    // We do this to avoid mutating our view of the menu until
    // after we have finished
    nsNativeMenuAutoUpdateBatch batch;

    SetPopupState(ePopupState_Hiding);
    DispatchMouseEvent(mPopupContent, eXULPopupHiding);

    // Sigh, make sure all of our descendants are closed, as we don't
    // always get closed events for submenus when scrubbing quickly through
    // the menu
    size_t count = ChildCount();
    for (size_t i = 0; i < count; ++i) {
        if (ChildAt(i)->Type() == nsMenuObject::eType_Menu) {
            static_cast<nsMenu *>(ChildAt(i))->OnClose();
        }
    }

    SetPopupState(ePopupState_Closed);
    DispatchMouseEvent(mPopupContent, eXULPopupHidden);

    ContentNode()->UnsetAttr(kNameSpaceID_None, nsGkAtoms::open, true);
}

void
nsMenu::OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute)
{
    NS_ASSERTION(aContent == ContentNode() || aContent == mPopupContent,
                 "Received an event that wasn't meant for us!");

    if (aAttribute == nsGkAtoms::open) {
        return;
    }

    if (Parent()->NeedsRebuild()) {
        return;
    }

    if (aContent == ContentNode()) {
        if (aAttribute == nsGkAtoms::disabled) {
            UpdateSensitivity();
        } else if (aAttribute == nsGkAtoms::label || 
                   aAttribute == nsGkAtoms::accesskey ||
                   aAttribute == nsGkAtoms::crop) {
            UpdateLabel();
        }
    }

    if (!Parent()->IsBeingDisplayed() || aContent != ContentNode()) {
        return;
    }

    if (aAttribute == nsGkAtoms::hidden ||
        aAttribute == nsGkAtoms::collapsed) {
        RefPtr<nsStyleContext> sc = GetStyleContext();
        UpdateVisibility(sc);
    } else if (aAttribute == nsGkAtoms::image) {
        RefPtr<nsStyleContext> sc = GetStyleContext();
        UpdateIcon(sc);
    }
}

void
nsMenu::OnContentInserted(nsIContent *aContainer, nsIContent *aChild,
                          nsIContent *aPrevSibling)
{
    NS_ASSERTION(aContainer == ContentNode() || aContainer == mPopupContent,
                 "Received an event that wasn't meant for us!");

    if (NeedsRebuild()) {
        return;
    }

    if (PopupState() == ePopupState_Closed) {
        SetNeedsRebuild(true);
        return;
    }

    if (aContainer == mPopupContent) {
        nsresult rv;
        nsMenuObject *child = CreateChild(aChild, &rv);

        if (child) {
            rv = InsertChildAfter(child, aPrevSibling);
        }
        if (NS_FAILED(rv)) {
            NS_ERROR("OnContentInserted() failed");
            SetNeedsRebuild(true);
        }
    } else {
        Build();
    }
}

void
nsMenu::OnContentRemoved(nsIContent *aContainer, nsIContent *aChild)
{
    NS_ASSERTION(aContainer == ContentNode() || aContainer == mPopupContent,
                 "Received an event that wasn't meant for us!");

    if (NeedsRebuild()) {
        return;
    }

    if (PopupState() == ePopupState_Closed) {
        SetNeedsRebuild(true);
        return;
    }

    if (aContainer == mPopupContent) {
        if (NS_FAILED(RemoveChild(aChild))) {
            NS_ERROR("OnContentRemoved() failed");
            SetNeedsRebuild(true);
        }
    } else {
        Build();
    }
}

/*
 * Some menus (eg, the History menu in Firefox) refresh themselves on
 * opening by removing all children and then re-adding new ones. As this
 * happens whilst the menu is opening in Unity, it causes some flickering
 * as the menu popup is resized multiple times. To avoid this, we try to
 * reuse native menu items when the menu structure changes during a
 * batched update. If we can handle menu structure changes from Gecko
 * just by updating properties of native menu items (rather than destroying
 * and creating new ones), then we eliminate any flickering that occurs as
 * the menu is opened. To do this, we don't modify any native menu items
 * until the end of the update batch.
 */

void
nsMenu::BeginUpdateBatch(nsIContent *aContent)
{
    NS_ASSERTION(aContent == ContentNode() || aContent == mPopupContent,
                 "Received an event that wasn't meant for us!");

    if (aContent == mPopupContent) {
        BeginUpdateBatchInternal();
    }
}

void
nsMenu::EndUpdateBatch()
{
    NS_ASSERTION(IsInUpdateBatch(), "Not in an update batch");

    SetIsInUpdateBatch(false);

    /* Optimize for the case where we only had attribute changes */
    if (!DidStructureMutate()) {
        return;
    }

    if (!EnsureNoPlaceholderItem()) {
        SetNeedsRebuild(true);
        return;
    }

    GList *nextNativeChild = dbusmenu_menuitem_get_children(GetNativeData());
    DbusmenuMenuitem *nextOwnedNativeChild = nullptr;

    size_t count = ChildCount();

    // Find the first native menu item that is `owned` by a corresponding
    // Gecko menuitem
    for (size_t i = 0; i < count; ++i) {
        if (ChildAt(i)->GetNativeData()) {
            nextOwnedNativeChild = ChildAt(i)->GetNativeData();
            break;
        }
    }

    // Now iterate over all Gecko menuitems
    for (size_t i = 0; i < count; ++i) {
        nsMenuObject *child = ChildAt(i);

        if (child->GetNativeData()) {
            // This child already has a corresponding native menuitem.
            // Remove all preceding orphaned native items. At this point, we
            // modify the native menu structure.
            while (nextNativeChild &&
                   nextNativeChild->data != nextOwnedNativeChild) {

                DbusmenuMenuitem *data =
                    static_cast<DbusmenuMenuitem *>(nextNativeChild->data);
                nextNativeChild = nextNativeChild->next;

                if (!dbusmenu_menuitem_child_delete(GetNativeData(), data)) {
                    NS_ERROR("Failed to remove orphaned native item from menu");
                    SetNeedsRebuild(true);
                    return;
                }
            }

            if (nextNativeChild) {
                nextNativeChild = nextNativeChild->next;
            }

            // Now find the next native menu item that is `owned`
            nextOwnedNativeChild = nullptr;
            for (size_t j = i + 1; j < count; ++j) {
                if (ChildAt(j)->GetNativeData()) {
                    nextOwnedNativeChild = ChildAt(j)->GetNativeData();
                    break;
                }
            }
        } else {
            // This child is new, and doesn't have a native menu item. Find one!
            if (nextNativeChild &&
                nextNativeChild->data != nextOwnedNativeChild) {

                DbusmenuMenuitem *data =
                    static_cast<DbusmenuMenuitem *>(nextNativeChild->data);

                if (NS_SUCCEEDED(child->AdoptNativeData(data))) {
                    nextNativeChild = nextNativeChild->next;
                }
            }

            // There wasn't a suitable one available, so create a new one.
            // At this point, we modify the native menu structure.
            if (!child->GetNativeData()) {
                child->CreateNativeData();
                if (!dbusmenu_menuitem_child_add_position(GetNativeData(),
                                                          child->GetNativeData(),
                                                          i)) {
                    NS_ERROR("Failed to add new native item");
                    SetNeedsRebuild(true);
                    return;
                }
            }
        }
    }

    while (nextNativeChild) {

        DbusmenuMenuitem *data =
            static_cast<DbusmenuMenuitem *>(nextNativeChild->data);
        nextNativeChild = nextNativeChild->next;

        if (!dbusmenu_menuitem_child_delete(GetNativeData(), data)) {
            NS_ERROR("Failed to remove orphaned native item from menu");
            SetNeedsRebuild(true);
            return;
        }
    }

    MaybeAddPlaceholderItem();
}
