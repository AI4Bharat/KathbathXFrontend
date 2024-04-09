package com.ai4bharat.karya.ui.crowdsource.login

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.manager.BaseUrlManager
import com.ai4bharat.karya.data.model.karya.WorkerRecord
import com.ai4bharat.karya.data.repo.WorkerRepository
import com.ai4bharat.karya.ui.crowdsource.registration.Language
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import javax.inject.Inject
import kotlin.math.log

@HiltViewModel
class CrowdsourceLoginViewModel
@Inject
constructor(
    private val workerRepository: WorkerRepository,
    private val authManager: AuthManager,
    private val baseUrlManager: BaseUrlManager
) : ViewModel() {

    private var loginUser: MutableLiveData<LoginUser> = MutableLiveData<LoginUser>()
    var loginUserError: MutableLiveData<LoginUserError> = MutableLiveData<LoginUserError>()
    var loginStatus: MutableLiveData<LoginStatus> =
        MutableLiveData<LoginStatus>(LoginStatus(Status.INITIAL, ""))

    fun setData(phoneNumber: String = "", language: Language) {
        loginUser.value = LoginUser(phoneNumber, language)
    }

    private fun inputValidation(): Boolean {
        val phoneNumberError: LoginError = loginUser.value!!.checkPhoneNumber()
        val tmpLoginUserError = LoginUserError(phoneNumberError)
        loginUserError.value = tmpLoginUserError
        return phoneNumberError.status
    }

    private fun createAccessCodeFromPhone(phoneNumber: String, language: Language): String {
        when (language) {
            Language.marathi -> return phoneNumber + "222222" + "2"
            Language.maithili -> return phoneNumber + "222222" + "3"
            Language.dogri -> return phoneNumber + "222222" + "4"
            Language.bengali -> return phoneNumber + "222222" + "5"
            Language.odia -> return phoneNumber + "222222" + "6"
            Language.kashmiri -> return phoneNumber + "222222" + "7"
            Language.sanskrit -> return phoneNumber + "222222" + "8"
            Language.assamese -> return phoneNumber + "222222" + "9"
            Language.malayalam -> return phoneNumber + "222222" + "10"
            Language.tamil -> return phoneNumber + "222222" + "11"
            Language.gujarati -> return phoneNumber + "222222" + "12"
            Language.bodo -> return phoneNumber + "222222" + "13"
            Language.nepali -> return phoneNumber + "222222" + "14"
            Language.konkani -> return phoneNumber + "222222" + "15"
            Language.telugu -> return phoneNumber + "222222" + "16"
            Language.santali -> return phoneNumber + "222222" + "17"
            Language.punjabi -> return phoneNumber + "222222" + "18"
            Language.hindi -> return phoneNumber + "222222" + "19"
            Language.sindhi -> return phoneNumber + "222222" + "20"
            Language.urdu -> return phoneNumber + "222222" + "21"
            Language.kannada -> return phoneNumber + "222222" + "22"
            Language.manipuri -> return phoneNumber + "222222" + "23"
        }
    }

    fun login() {
        // Return true if the inputs are INVALID
        println(viewModelScope)
        val inputIsInValid: Boolean = inputValidation()
        print(inputIsInValid)
        if (inputIsInValid) {
            println("Invalid params")
        } else {
            val accessCode: String =
                createAccessCodeFromPhone(loginUser.value!!.phoneNumber, loginUser.value!!.language)
            workerRepository.verifyAccessCode(accessCode)
                .onStart { loginStatus.value = LoginStatus(Status.LOADING, "") }
                .onEach { workerRecord ->
                    generateAndVerifyOTP(accessCode, loginUser.value!!.phoneNumber)
                }
                .catch {
                    loginStatus.value = LoginStatus(Status.FAILED, "Login Failed")
                }.launchIn(viewModelScope)
        }
    }

    // Need to do this for the getting the id token
    private fun generateAndVerifyOTP(
        accessCode: String,
        phoneNumber: String,
        otp: String = "112233"
    ) {
        println("Generating the OTP")
        workerRepository.getOTP(accessCode, phoneNumber)
            .onStart { println("Starting OTP generation") }
            .onEach {
                println("OTP generation was successful")
                loginStatus.value = LoginStatus(Status.LOADING, "")
            }.catch {
                loginStatus.value = LoginStatus(Status.FAILED, "Login Failed ")
            }.launchIn(viewModelScope)

        if (loginStatus.value?.status == Status.LOADING) {
            workerRepository.verifyOTP(accessCode, phoneNumber, otp)
                .onStart { println("OTP verification started") }
                .onEach { workerRecord ->
                    createWorker(accessCode, workerRecord)
                    authManager.updateLoggedInWorker(workerRecord.id)
                    loginStatus.value = LoginStatus(Status.SUCCESS, "")
                }.catch {
                    loginStatus.value = LoginStatus(Status.FAILED, "Login Failed")
                }.launchIn(viewModelScope)
        }
    }

    private fun createWorker(accessCode: String, workerRecord: WorkerRecord) {
        val dbWorker = workerRecord.copy(accessCode = accessCode)
        viewModelScope.launch { workerRepository.upsertWorker(dbWorker) }
    }
}