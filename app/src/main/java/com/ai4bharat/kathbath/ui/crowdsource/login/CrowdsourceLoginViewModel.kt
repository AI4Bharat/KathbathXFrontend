package com.ai4bharat.kathbath.ui.crowdsource.login

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.manager.BaseUrlManager
import com.ai4bharat.kathbath.data.model.karya.WorkerRecord
import com.ai4bharat.kathbath.data.repo.WorkerRepository
import com.ai4bharat.kathbath.ui.crowdsource.registration.Language
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import javax.inject.Inject

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

    fun setData(phoneNumber: String = "", language: String) {
        loginUser.value = LoginUser(phoneNumber, language)
    }

    private fun inputValidation(): Boolean {
        val phoneNumberError: LoginError = loginUser.value!!.checkPhoneNumber()
        val languageError: LoginError = loginUser.value!!.checkLanguage()
        val tmpLoginUserError = LoginUserError(phoneNumberError, languageError)
        loginUserError.value = tmpLoginUserError
        println("The language error is $languageError")
        return phoneNumberError.status || languageError.status
    }

    private fun createAccessCodeFromPhone(phoneNumber: String, language: String): String {
        when (language) {
            Language.marathi.name -> return phoneNumber + "222222" + "2"
            Language.maithili.name -> return phoneNumber + "222222" + "3"
            Language.dogri.name -> return phoneNumber + "222222" + "4"
            Language.bengali.name -> return phoneNumber + "222222" + "5"
            Language.odia.name -> return phoneNumber + "222222" + "6"
            Language.kashmiri.name -> return phoneNumber + "222222" + "7"
            Language.sanskrit.name -> return phoneNumber + "222222" + "8"
            Language.assamese.name -> return phoneNumber + "222222" + "9"
            Language.malayalam.name -> return phoneNumber + "222222" + "10"
            Language.tamil.name -> return phoneNumber + "222222" + "11"
            Language.gujarati.name -> return phoneNumber + "222222" + "12"
            Language.bodo.name -> return phoneNumber + "222222" + "13"
            Language.nepali.name -> return phoneNumber + "222222" + "14"
            Language.konkani.name -> return phoneNumber + "222222" + "15"
            Language.telugu.name -> return phoneNumber + "222222" + "16"
            Language.santali.name -> return phoneNumber + "222222" + "17"
            Language.punjabi.name -> return phoneNumber + "222222" + "18"
            Language.hindi.name -> return phoneNumber + "222222" + "19"
            Language.sindhi.name -> return phoneNumber + "222222" + "20"
            Language.urdu.name -> return phoneNumber + "222222" + "21"
            Language.kannada.name -> return phoneNumber + "222222" + "22"
            Language.manipuri.name -> return phoneNumber + "222222" + "23"
            else -> return "invalid"
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

            println("The access code is $accessCode ${loginUser.value!!.language}")
            if (accessCode == "invalid") {
//                loginUserError  =
//                    LoginError("language", "Invalid Language", true)
                return
            }
            println("login started")
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