@file:Suppress("NAME_SHADOWING")

package com.ai4bharat.karya.ui.onboarding.login.otp

import android.location.Location
import android.location.LocationManager
import android.os.Build
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.BuildConfig
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.model.karya.WorkerRecord
import com.ai4bharat.karya.data.remote.request.RegisterOrUpdateWorkerRequest
import com.ai4bharat.karya.data.repo.WorkerRepository
import com.ai4bharat.karya.ui.Destination
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.gson.*
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import org.json.JSONObject
import org.json.JSONStringer
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*
import javax.inject.Inject
import kotlin.reflect.typeOf

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

  lateinit var extraLocation:JsonObject
  private val KARYA_KEY = "KaryaExtrasDC"
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

  private fun getFreshExtras(): JsonArray {
    val phone = JsonObject()
    phone.addProperty("manufacturer",Build.MANUFACTURER)
    phone.addProperty("model",Build.MODEL)
    phone.addProperty("product",Build.PRODUCT)
    phone.addProperty("app_version", BuildConfig.VERSION_CODE.toString())

    val extrasElement = JsonObject()
    extrasElement.add("location",extraLocation)
    extrasElement.add("phone",phone)
    extrasElement.addProperty("date",LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm")
    ).toString())

    val extrasArray = JsonArray()
    extrasArray.add(extrasElement)

//    Log.e("EXTRASARRAY",extrasArray.toString())
//    val extrasKarya = JsonObject()
//    extrasKarya.add("karya",extrasArray)
    return extrasArray
  }

  fun verifyOTP(otp: String) {
    viewModelScope.launch {
      _otpUiState.value = OTPUiState.Loading
      // We updated the worker phone number during first otp call, let's reuse that
      val worker = authManager.getLoggedInWorker()
      checkNotNull(worker.phoneNumber)

      val extrasRaw = getFreshExtras()
      workerRepository
        .verifyOTP(accessCode = worker.accessCode, phoneNumber = worker.phoneNumber, otp)
        .onEach { worker ->
          val oldExtras = worker.extras

          if (!oldExtras!!.isJsonNull) {
            if ((oldExtras as JsonObject).keySet().contains(KARYA_KEY)) {
                extrasRaw.addAll(oldExtras[KARYA_KEY] as JsonArray)
//              extrasRaw.addAll(Gson().fromJson(Json.parseToJsonElement(oldExtras.asJsonObject.get(
//                KARYA_KEY).asString).jsonArray.toString(), JsonArray::class.java))
//              Log.e("ONE",Gson().fromJson(Json.parseToJsonElement(oldExtras.asJsonObject.get(
//                KARYA_KEY).asString).jsonArray.toString(), JsonArray::class.java).toString())
            }
            else {
              extrasRaw.add(oldExtras as JsonObject)
//              extrasRaw.add(Gson().fromJson(Json.parseToJsonElement(oldExtras.asJsonObject.toString()).jsonObject.toString(),
//                JsonObject::class.java))
//              Log.e("ONE",Gson().fromJson(Json.parseToJsonElement(oldExtras.asJsonObject.toString()).jsonObject.toString(),
//                JsonObject::class.java).toString())
            }
          }
          val extras = JsonObject()
//          Log.e("ONE",Gson().toJson(extrasRaw).toString())
//          extras.addProperty(KARYA_KEY,Gson().toJson(extrasRaw))
          extras.add(KARYA_KEY,extrasRaw)
          val updatedWorker = worker.copy(extras = extras, isConsentProvided = true)

          workerRepository.updateWorker(
            worker.idToken.toString(),"update",RegisterOrUpdateWorkerRequest(extras)
            )
            .catch { throwable -> Log.e("TRYING_UPDATE",throwable.toString()) }
            .collect {
                worker -> workerRepository.upsertWorker(updatedWorker)
            }
          workerRepository.upsertWorker(updatedWorker)
          authManager.startSession(worker.copy(isConsentProvided = true))

          _otpUiState.value = OTPUiState.Success

          handleNavigation(worker)
        }
        .catch {
            throwable -> _otpUiState.value = OTPUiState.Error(throwable) }
        .collect()
    }
  }

  private suspend fun handleNavigation(worker: WorkerRecord) {
    val destination = Destination.Dashboard
    _otpEffects.emit(OTPEffects.Navigate(destination))
  }
}
