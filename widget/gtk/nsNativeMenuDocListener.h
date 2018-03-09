/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsNativeMenuDocListener_h__
#define __nsNativeMenuDocListener_h__

#include "mozilla/Attributes.h"
#include "mozilla/GuardObjects.h"
#include "mozilla/RefPtr.h"
#include "nsAutoPtr.h"
#include "nsDataHashtable.h"
#include "nsStubMutationObserver.h"
#include "nsTArray.h"

class nsIAtom;
class nsIContent;
class nsIDocument;
class nsNativeMenuChangeObserver;

/*
 * This class keeps a mapping of content nodes to observers and forwards DOM
 * mutations to these. There is exactly one of these for every menubar.
 */
class nsNativeMenuDocListener final : nsStubMutationObserver
{
public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED
    NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED

    static already_AddRefed<nsNativeMenuDocListener> Create(nsIContent *aRootNode);

    // Register an observer to receive mutation events for the specified
    // content node. The caller must keep the observer alive until
    // UnregisterForContentChanges is called.
    void RegisterForContentChanges(nsIContent *aContent,
                                   nsNativeMenuChangeObserver *aObserver);

    // Unregister the registered observer for the specified content node
    void UnregisterForContentChanges(nsIContent *aContent);

    // Start listening to the document and forwarding DOM mutations to
    // registered observers.
    void Start();

    // Stop listening to the document. No DOM mutations will be forwarded
    // to registered observers.
    void Stop();

private:
    friend class nsNativeMenuAutoUpdateBatch;
    friend class DispatchHelper;

    struct MutationRecord {
        enum RecordType {
            eAttributeChanged,
            eContentInserted,
            eContentRemoved
        } mType;

        nsCOMPtr<nsIContent> mTarget;
        nsCOMPtr<nsIContent> mChild;
        nsCOMPtr<nsIContent> mPrevSibling;
        nsCOMPtr<nsIAtom> mAttribute;
    };

    nsNativeMenuDocListener();
    ~nsNativeMenuDocListener();
    nsresult Init(nsIContent *aRootNode);

    void DoAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute);
    void DoContentInserted(nsIContent *aContainer,
                           nsIContent *aChild,
                           nsIContent *aPrevSibling);
    void DoContentRemoved(nsIContent *aContainer, nsIContent *aChild);
    void DoBeginUpdateBatch(nsIContent *aTarget);
    void DoEndUpdateBatch(nsIContent *aTarget);
    void FlushPendingMutations();
    static void ScheduleFlush(nsNativeMenuDocListener *aListener);
    static void CancelFlush(nsNativeMenuDocListener *aListener);
    static void BeginUpdates() { ++sUpdateDepth; }
    static void EndUpdates();

    nsCOMPtr<nsIContent> mRootNode;
    nsIDocument *mDocument;
    nsIContent *mLastSource;
    nsNativeMenuChangeObserver *mLastTarget;
    nsTArray<nsAutoPtr<MutationRecord> > mPendingMutations;
    nsDataHashtable<nsPtrHashKey<nsIContent>, nsNativeMenuChangeObserver*> mContentToObserverTable;

    static uint32_t sUpdateDepth;
};

typedef nsTArray<RefPtr<nsNativeMenuDocListener> > nsNativeMenuDocListenerTArray;

class nsNativeMenuChangeObserver
{
public:
    virtual void OnAttributeChanged(nsIContent *aContent, nsIAtom *aAttribute)
    {
        NS_ERROR("Unhandled AttributeChanged() notification");
    }

    virtual void OnContentInserted(nsIContent *aContainer,
                                   nsIContent *aChild,
                                   nsIContent *aPrevSibling)
    {
        NS_ERROR("Unhandled ContentInserted() notification");
    }

    virtual void OnContentRemoved(nsIContent *aContainer, nsIContent *aChild)
    {
        NS_ERROR("Unhandled ContentRemoved() notification");
    }

    virtual void BeginUpdateBatch(nsIContent *aContent) { };

    virtual void EndUpdateBatch() { };
};

/*
 * This class is intended to be used inside GObject signal handlers.
 * It allows us to queue updates until we have finished delivering
 * events to Gecko, and then we can batch updates to our view of the
 * menu. This allows us to do menu updates without altering the structure
 * seen by the OS.
 */
class MOZ_STACK_CLASS nsNativeMenuAutoUpdateBatch
{
public:
    nsNativeMenuAutoUpdateBatch(MOZ_GUARD_OBJECT_NOTIFIER_ONLY_PARAM)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        nsNativeMenuDocListener::BeginUpdates();
    }

    ~nsNativeMenuAutoUpdateBatch()
    {
        nsNativeMenuDocListener::EndUpdates();
    }

private:
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

#endif /* __nsNativeMenuDocListener_h__ */
