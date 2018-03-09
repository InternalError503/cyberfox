/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsMenuItem_h__
#define __nsMenuItem_h__

#include "mozilla/Attributes.h"
#include "nsCOMPtr.h"

#include "nsDbusmenu.h"
#include "nsMenuObject.h"

#include <glib.h>

#define NSMENUITEM_NUMBER_OF_TYPE_BITS 2U
#define NSMENUITEM_NUMBER_OF_FLAGS     1U

class nsIAtom;
class nsIContent;
class nsStyleContext;
class nsMenuBar;
class nsMenuContainer;

/*
 * This class represents 3 main classes of menuitems: labels, checkboxes and
 * radio buttons (with/without an icon)
 */
class nsMenuItem final : public nsMenuObject
{
public:
    ~nsMenuItem();

    nsMenuObject::EType Type() const;

    static nsMenuObject* Create(nsMenuContainer *aParent,
                                nsIContent *aContent);

    void OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute);

private:
    friend class nsMenuItemUncheckSiblingsRunnable;

    enum {
        eMenuItemFlag_ToggleState = (1 << 0)
    };

    enum EMenuItemType {
        eMenuItemType_Normal,
        eMenuItemType_Radio,
        eMenuItemType_CheckBox
    };

    nsMenuItem();

    EMenuItemType MenuItemType() const
    {
        return static_cast<EMenuItemType>(
            (GetFlags() &
             (((1U << NSMENUITEM_NUMBER_OF_TYPE_BITS) - 1U)
              << NSMENUITEM_NUMBER_OF_FLAGS)) >> NSMENUITEM_NUMBER_OF_FLAGS);
    }
    void SetMenuItemType(EMenuItemType aType)
    {
        ClearFlags(((1U << NSMENUITEM_NUMBER_OF_TYPE_BITS) - 1U) << NSMENUITEM_NUMBER_OF_FLAGS);
        SetFlags(aType << NSMENUITEM_NUMBER_OF_FLAGS);
    }
    bool IsCheckboxOrRadioItem() const;

    bool IsChecked() const
    {
        return HasFlags(eMenuItemFlag_ToggleState);
    }
    void SetCheckState(bool aState)
    {
        if (aState) {
            SetFlags(eMenuItemFlag_ToggleState);
        } else {
            ClearFlags(eMenuItemFlag_ToggleState);
        }
    }

    static void item_activated_cb(DbusmenuMenuitem *menuitem,
                                  guint timestamp,
                                  gpointer user_data);
    void Activate(uint32_t aTimestamp);

    void CopyAttrFromNodeIfExists(nsIContent *aContent, nsIAtom *aAtom);
    void UpdateState();
    void UpdateTypeAndState();
    void UpdateAccel();

    void InitializeNativeData();
    void UpdateContentAttributes();
    void Update(nsStyleContext *aStyleContext);
    void UncheckSiblings();
    bool IsCompatibleWithNativeData(DbusmenuMenuitem *aNativeData) const;
    nsMenuBar* MenuBar();
    nsMenuObject::PropertyFlags SupportedProperties() const;

    nsCOMPtr<nsIContent> mKeyContent;
};

#endif /* __nsMenuItem_h__ */
