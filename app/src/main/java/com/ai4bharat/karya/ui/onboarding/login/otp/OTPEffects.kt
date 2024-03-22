package com.ai4bharat.karya.ui.onboarding.login.otp

import com.ai4bharat.karya.ui.Destination

sealed class OTPEffects {
  data class Navigate(val destination: Destination) : OTPEffects()
}
