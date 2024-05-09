@file:Suppress("NAME_SHADOWING")

package com.ai4bharat.karyatts.ui.onboarding.login.otp

import android.os.Build
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karyatts.data.manager.AuthManager
import com.ai4bharat.karyatts.data.model.karya.WorkerRecord
import com.ai4bharat.karyatts.data.remote.request.RegisterOrUpdateWorkerRequest
import com.ai4bharat.karyatts.data.repo.WorkerRepository
import com.ai4bharat.karyatts.ui.Destination
import com.google.gson.JsonParser
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class OTPViewModel
@Inject
constructor(
  private val authManager: AuthManager,
  private val workerRepository: WorkerRepository,
) : ViewModel() {

  private val _otpUiState: MutableStateFlow<OTPUiState> = MutableStateFlow(OTPUiState.Initial)
  val otpUiState = _otpUiState.asStateFlow()

  private val _otpEffects: MutableSharedFlow<OTPEffects> = MutableSharedFlow()
  val otpEffects = _otpEffects.asSharedFlow()

  private var _phoneNumber: MutableStateFlow<String> = MutableStateFlow("...")
  var phoneNumber = _phoneNumber.asSharedFlow()

  var consent_form:String = ""
  /**
   * Get the phone number of the worker to replace in the text.
   */
  fun retrievePhoneNumber() {
    viewModelScope.launch {
      val worker = authManager.getLoggedInWorker()
      _phoneNumber.value = worker.phoneNumber ?: "..."
    }
  }

  fun resendOTP() {
    viewModelScope.launch {
      _otpUiState.value = OTPUiState.Loading

      // We updated the worker phone number during first otp call, let's reuse that
      val worker = authManager.getLoggedInWorker()
      checkNotNull(worker.phoneNumber)

      workerRepository
        .resendOTP(accessCode = worker.accessCode, phoneNumber = worker.phoneNumber)
        .onEach { _otpUiState.value = OTPUiState.Initial }
        .catch { throwable -> _otpUiState.value = OTPUiState.Error(throwable) }
        .collect()
    }
  }

  fun verifyOTP(otp: String) {
    viewModelScope.launch {
      _otpUiState.value = OTPUiState.Loading

      // We updated the worker phone number during first otp call, let's reuse that
      val worker = authManager.getLoggedInWorker()
      checkNotNull(worker.phoneNumber)

      workerRepository
        .verifyOTP(accessCode = worker.accessCode, phoneNumber = worker.phoneNumber, otp)
        .onEach { worker ->
          val extras = JsonParser.parseString("{\"phone_details\":{\"manufacturer\":\"" + Build.MANUFACTURER + "\",\"model\":\"" + Build.MODEL + "\",\"product\":\"" + Build.PRODUCT + "\"}," +
                  "\"consent_details\":\""+ consent_form +"\"}");
          val updatedWorker = worker.copy(extras = extras, isConsentProvided = true)
          workerRepository.updateWorker(worker.idToken.toString(),"update",RegisterOrUpdateWorkerRequest(extras))
            .catch { throwable -> Log.e("TRYING_UPDATE",throwable.toString()) }
            .collect {
                worker -> workerRepository.upsertWorker(updatedWorker)

            }
//          workerRepository.upsertWorker(updatedWorker)
          authManager.startSession(worker.copy(isConsentProvided = true))
          _otpUiState.value = OTPUiState.Success

          handleNavigation(worker)
        }
        .catch { throwable -> _otpUiState.value = OTPUiState.Error(throwable) }
        .collect()
    }
  }

  private suspend fun handleNavigation(worker: WorkerRecord) {
    val destination = Destination.Dashboard
    _otpEffects.emit(OTPEffects.Navigate(destination))
  }
}
