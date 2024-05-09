package com.ai4bharat.karyatts.ui.splashScreen

sealed class SplashEffects {
  data class UpdateLanguage(val language: String) : SplashEffects()
}
