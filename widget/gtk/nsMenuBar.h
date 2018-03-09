/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsMenuBar_h__
#define __nsMenuBar_h__

#include "mozilla/Attributes.h"
#include "nsCOMPtr.h"
#include "nsString.h"

#include "nsDbusmenu.h"
#include "nsMenuContainer.h"
#include "nsMenuObject.h"
#include "nsNativeMenuUtils.h"

#include <gtk/gtk.h>

class nsIAtom;
class nsIContent;
class nsIDOMEvent;
class nsIDOMKeyEvent;
class nsIWidget;
class nsMenuBarDocEventListener;

/*
 * The menubar class. There is one of these per window (and the window
 * owns its menubar). Each menubar has an object path, and the service is
 * responsible for telling the desktop shell which object path corresponds
 * to a particular window. A menubar and its hierarchy also own a
 * nsNativeMenuDocListener.
 */
class nsMenuBar final : public nsMenuContainer
{
public:
    ~nsMenuBar();

    static nsMenuBar* Create(nsIWidget *aParent,
                             nsIContent *aMenuBarNode);

    nsMenuObject::EType Type() const;

    bool IsBeingDisplayed() const;

    // Get the native window ID for this menubar
    uint32_t WindowId() const;

    // Get the object path for this menubar
    nsAdoptingCString ObjectPath() const;

    // Initializes and returns a cancellable request object, used
    // by the menuservice when registering this menubar
    nsNativeMenuGIORequest& BeginRegisterRequest();

    // Finishes the current request to register the menubar
    void EndRegisterRequest();

    bool RegisterRequestInProgress() const;

    // Get the top-level GtkWindow handle
    GtkWidget* TopLevelWindow() { return mTopLevel; }

    // Called from the menuservice when the menubar is about to be registered.
    // Causes the native menubar to be created, and the XUL menubar to be hidden
    void Activate();

    // Called from the menuservice when the menubar is no longer registered
    // with the desktop shell. Will cause the XUL menubar to be shown again
    void Deactivate();

    void OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute);
    void OnContentInserted(nsIContent *aContainer, nsIContent *aChild,
                           nsIContent *aPrevSibling);
    void OnContentRemoved(nsIContent *aContainer, nsIContent *aChild);

private:
    friend class nsMenuBarDocEventListener;

    enum ModifierFlags {
        eModifierShift = (1 << 0),
        eModifierCtrl = (1 << 1),
        eModifierAlt = (1 << 2),
        eModifierMeta = (1 << 3)
    };

    nsMenuBar();
    nsresult Init(nsIWidget *aParent, nsIContent *aMenuBarNode);
    void Build();
    void DisconnectDocumentEventListeners();
    void SetShellShowingMenuBar(bool aShowing);
    void Focus();
    void Blur();
    ModifierFlags GetModifiersFromEvent(nsIDOMKeyEvent *aEvent);
    nsresult Keypress(nsIDOMEvent *aEvent);
    nsresult KeyDown(nsIDOMEvent *aEvent);
    nsresult KeyUp(nsIDOMEvent *aEvent);

    GtkWidget *mTopLevel;
    DbusmenuServer *mServer;
    nsCOMPtr<nsIDOMEventTarget> mDocument;
    nsNativeMenuGIORequest mRegisterRequestCanceller;
    RefPtr<nsMenuBarDocEventListener> mEventListener;

    uint32_t mAccessKey;
    ModifierFlags mAccessKeyMask;
    bool mIsActive;
};

#endif /* __nsMenuBar_h__ */
