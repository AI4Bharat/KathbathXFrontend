package com.ai4bharat.karyatts.ui.onboarding.login.otp

import com.ai4bharat.karyatts.ui.Destination

sealed class OTPEffects {
  data class Navigate(val destination: Destination) : OTPEffects()
}
