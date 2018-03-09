/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsGkAtoms.h"
#include "nsIAtom.h"
#include "nsIContent.h"

#include "nsDbusmenu.h"
#include "nsMenu.h"
#include "nsMenuItem.h"
#include "nsMenuSeparator.h"

#include "nsMenuContainer.h"

const nsMenuContainer::ChildTArray::index_type nsMenuContainer::NoIndex = nsMenuContainer::ChildTArray::NoIndex;

typedef nsMenuObject* (*nsMenuObjectConstructor)(nsMenuContainer*,
                                                 nsIContent*);
static nsMenuObjectConstructor
GetMenuObjectConstructor(nsIContent *aContent)
{
    if (aContent->IsXULElement(nsGkAtoms::menuitem)) {
        return nsMenuItem::Create;
    } else if (aContent->IsXULElement(nsGkAtoms::menu)) {
        return nsMenu::Create;
    } else if (aContent->IsXULElement(nsGkAtoms::menuseparator)) {
        return nsMenuSeparator::Create;
    }

    return nullptr;
}

static bool
ContentIsSupported(nsIContent *aContent)
{
    return GetMenuObjectConstructor(aContent) ? true : false;
}

nsMenuObject*
nsMenuContainer::CreateChild(nsIContent *aContent, nsresult *aRv)
{
    nsMenuObjectConstructor ctor = GetMenuObjectConstructor(aContent);
    if (!ctor) {
        // There are plenty of node types we might stumble across that
        // aren't supported. This isn't an error though
        if (aRv) {
            *aRv = NS_OK;
        }
        return nullptr;
    }

    nsMenuObject *res = ctor(this, aContent);
    if (!res) {
        if (aRv) {
            *aRv = NS_ERROR_FAILURE;
        }
        return nullptr;
    }

    if (aRv) {
        *aRv = NS_OK;
    }
    return res;
}

size_t
nsMenuContainer::IndexOf(nsIContent *aChild) const
{
    if (!aChild) {
        return NoIndex;
    }

    size_t count = ChildCount();
    for (size_t i = 0; i < count; ++i) {
        if (ChildAt(i)->ContentNode() == aChild) {
            return i;
        }
    }

    return NoIndex;
}

nsresult
nsMenuContainer::RemoveChildAt(size_t aIndex, bool aUpdateNative)
{
    if (aIndex >= ChildCount()) {
        return NS_ERROR_INVALID_ARG;
    }

    if (aUpdateNative) {
        if (!dbusmenu_menuitem_child_delete(GetNativeData(),
                                            ChildAt(aIndex)->GetNativeData())) {
            return NS_ERROR_FAILURE;
        }
    }

    mChildren.RemoveElementAt(aIndex);

    return NS_OK;
}

nsresult
nsMenuContainer::RemoveChild(nsIContent *aChild, bool aUpdateNative)
{
    size_t index = IndexOf(aChild);
    if (index == NoIndex) {
        return NS_ERROR_INVALID_ARG;
    }

    return RemoveChildAt(index, aUpdateNative);
}

nsresult
nsMenuContainer::InsertChildAfter(nsMenuObject *aChild,
                                  nsIContent *aPrevSibling,
                                  bool aUpdateNative)
{
    size_t index = IndexOf(aPrevSibling);
    if (index == NoIndex && aPrevSibling) {
        return NS_ERROR_INVALID_ARG;
    }

    ++index;

    if (aUpdateNative) {
        aChild->CreateNativeData();
        if (!dbusmenu_menuitem_child_add_position(GetNativeData(),
                                                  aChild->GetNativeData(),
                                                  index)) {
            return NS_ERROR_FAILURE;
        }
    }

    return mChildren.InsertElementAt(index, aChild) ? NS_OK : NS_ERROR_FAILURE;
}

nsresult
nsMenuContainer::AppendChild(nsMenuObject *aChild, bool aUpdateNative)
{
    if (aUpdateNative) {
        aChild->CreateNativeData();
        if (!dbusmenu_menuitem_child_append(GetNativeData(),
                                            aChild->GetNativeData())) {
            return NS_ERROR_FAILURE;
        }
    }

    return mChildren.AppendElement(aChild) ? NS_OK : NS_ERROR_FAILURE;
}

nsMenuContainer::nsMenuContainer() :
    nsMenuObject()
{
}

bool
nsMenuContainer::NeedsRebuild() const
{
    return false;
}

/* static */ nsIContent*
nsMenuContainer::GetPreviousSupportedSibling(nsIContent *aContent)
{
    do {
        aContent = aContent->GetPreviousSibling();
    } while (aContent && !ContentIsSupported(aContent));

    return aContent;
}
