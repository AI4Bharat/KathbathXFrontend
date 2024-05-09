// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

package com.ai4bharat.karyatts.data.model.karya.modelsExtra

data class IDToken(
  val sub: String,
  val iat: Int,
  val exp: Int,
  val aud: String,
)
