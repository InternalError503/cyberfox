/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsMenu_h__
#define __nsMenu_h__

#include "mozilla/Attributes.h"
#include "nsCOMPtr.h"

#include "nsDbusmenu.h"
#include "nsMenuContainer.h"
#include "nsMenuObject.h"

#include <glib.h>

class nsIAtom;
class nsIContent;
class nsStyleContext;

#define NSMENU_NUMBER_OF_POPUPSTATE_BITS 2U
#define NSMENU_NUMBER_OF_FLAGS           4U

// This class represents a menu
class nsMenu final : public nsMenuContainer
{
public:
    ~nsMenu();

    static nsMenuObject* Create(nsMenuContainer *aParent,
                                nsIContent *aContent);

    nsMenuObject::EType Type() const;

    bool IsBeingDisplayed() const;
    bool NeedsRebuild() const;

    // Tell the desktop shell to display this menu
    void OpenMenu();

    // Normally called via the shell, but it's public so that child
    // menuitems can do the shells work. Sigh....
    void OnClose();

    void OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute);
    void OnContentInserted(nsIContent *aContainer, nsIContent *aChild,
                           nsIContent *aPrevSibling);
    void OnContentRemoved(nsIContent *aContainer, nsIContent *aChild);
    void BeginUpdateBatch(nsIContent *aContent);
    void EndUpdateBatch();

private:
    friend class nsMenuUpdateBatch;

    enum {
        // This menu needs rebuilding the next time it is opened
        eFlag_NeedsRebuild = 1 << 0,

        // This menu contains a placeholder
        eFlag_HasPlaceholderItem = 1 << 1,

        // This menu is currently receiving a batch of updates, and
        // the native structure should not be modified
        eFlag_InUpdateBatch = 1 << 2,

        // Children were added to / removed from this menu (only valid
        // when eFlag_InUpdateBatch is set)
        eFlag_StructureMutated = 1 << 3
    };

    enum EPopupState {
        ePopupState_Closed,
        ePopupState_Showing,
        ePopupState_Open,
        ePopupState_Hiding
    };

    nsMenu();

    void SetNeedsRebuild(bool aValue)
    {
        if (aValue) {
            SetFlags(eFlag_NeedsRebuild);
        } else {
            ClearFlags(eFlag_NeedsRebuild);
        }
    }
    bool HasPlaceholderItem() const
    {
        return HasFlags(eFlag_HasPlaceholderItem);
    }
    void SetHasPlaceholderItem(bool aValue)
    {
        if (aValue) {
            SetFlags(eFlag_HasPlaceholderItem);
        } else {
            ClearFlags(eFlag_HasPlaceholderItem);
        }
    }

    bool IsInUpdateBatch() const
    {
        return HasFlags(eFlag_InUpdateBatch);
    }
    void SetIsInUpdateBatch(bool aValue)
    {
        if (aValue) {
            SetFlags(eFlag_InUpdateBatch);
        } else {
            ClearFlags(eFlag_InUpdateBatch);
        }
    }

    bool DidStructureMutate() const
    {
        return HasFlags(eFlag_StructureMutated);
    }
    void SetDidStructureMutate(bool aValue)
    {
        if (aValue) {
            SetFlags(eFlag_StructureMutated);
        } else {
            ClearFlags(eFlag_StructureMutated);
        }
    }

    EPopupState PopupState() const
    {
        return static_cast<EPopupState>(
            (GetFlags() &
             (((1U << NSMENU_NUMBER_OF_POPUPSTATE_BITS) - 1U)
              << NSMENU_NUMBER_OF_FLAGS)) >> NSMENU_NUMBER_OF_FLAGS);
    };
    void SetPopupState(EPopupState aState);

    static void menu_event_cb(DbusmenuMenuitem *menu,
                              const gchar *name,
                              GVariant *value,
                              guint timestamp,
                              gpointer user_data);

    // We add a placeholder item to empty menus so that Unity actually treats
    // us as a proper menu, rather than a menuitem without a submenu
    void MaybeAddPlaceholderItem();
    bool EnsureNoPlaceholderItem();

    void OnOpen();
    void Build();
    void InitializeNativeData();
    void Update(nsStyleContext *aStyleContext);
    void InitializePopup();
    void BeginUpdateBatchInternal();
    nsresult RemoveChildAt(size_t aIndex);
    nsresult RemoveChild(nsIContent *aChild);
    nsresult InsertChildAfter(nsMenuObject *aChild, nsIContent *aPrevSibling);
    nsresult AppendChild(nsMenuObject *aChild);
    bool CanOpen() const;
    nsMenuObject::PropertyFlags SupportedProperties() const;

    nsCOMPtr<nsIContent> mPopupContent;
};

#endif /* __nsMenu_h__ */
