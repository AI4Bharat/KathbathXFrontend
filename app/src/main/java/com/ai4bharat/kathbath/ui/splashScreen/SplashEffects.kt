package com.ai4bharat.kathbath.ui.splashScreen

sealed class SplashEffects {
  data class UpdateLanguage(val language: String) : SplashEffects()
}
