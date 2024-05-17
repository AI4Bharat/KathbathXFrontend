package com.ai4bharat.kathbath.ui.onboarding.login.otp

import com.ai4bharat.kathbath.ui.Destination

sealed class OTPEffects {
  data class Navigate(val destination: Destination) : OTPEffects()
}
