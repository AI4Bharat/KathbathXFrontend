package com.ai4bharat.karyatts.ui.onboarding.login.otp

sealed class OTPUiState {
  data class Error(val throwable: Throwable) : OTPUiState()
  object Initial : OTPUiState()
  object Loading : OTPUiState()
  object Success : OTPUiState()
}
