package com.ai4bharat.karya.ui.splashScreen

sealed class SplashEffects {
  data class UpdateLanguage(val language: String) : SplashEffects()
}
