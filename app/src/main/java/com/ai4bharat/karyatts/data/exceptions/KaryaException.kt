// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// Karya exception class. Defines exceptions using string resources rather than direct messages.

package com.ai4bharat.karyatts.data.exceptions

import android.content.Context
import androidx.annotation.StringRes
import com.ai4bharat.karyatts.R

open class KaryaException(@StringRes val errorId: Int = R.string.unknown_error): Throwable() {

  // Get message from context
  fun getMessage(context: Context): String {
    return context.getString(errorId)
  }
}
