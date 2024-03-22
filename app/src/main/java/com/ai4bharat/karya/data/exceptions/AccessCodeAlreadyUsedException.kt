// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// Exception raised when access code is already used

package com.ai4bharat.karya.data.exceptions

import com.ai4bharat.karya.R

class AccessCodeAlreadyUsedException : KaryaException(R.string.access_code_already_used)
