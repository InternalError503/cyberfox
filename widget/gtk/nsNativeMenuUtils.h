/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsNativeMenuUtils_h__
#define __nsNativeMenuUtils_h__

#include <glib-object.h>
#include <gio/gio.h>

class nsNativeMenuGIORequest
{
public:
    nsNativeMenuGIORequest() : mCancellable(nullptr) { };

    ~nsNativeMenuGIORequest() {
        Cancel();
    }

    void Start() {
        Cancel();
        mCancellable = g_cancellable_new();
    }

    void Finish() {
        if (mCancellable) {
            g_object_unref(mCancellable);
            mCancellable = nullptr;
        }
    }

    void Cancel() {
        if (mCancellable) {
            g_cancellable_cancel(mCancellable);
            g_object_unref(mCancellable);
            mCancellable = nullptr;
        }
    }

    bool InProgress() const {
        if (!mCancellable) {
            return false;
        }

        return !g_cancellable_is_cancelled(mCancellable);
    }

    operator GCancellable*() const {
        return mCancellable;
    }

private:
    GCancellable *mCancellable;
};

#endif /* __nsNativeMenuUtils_h__ */
