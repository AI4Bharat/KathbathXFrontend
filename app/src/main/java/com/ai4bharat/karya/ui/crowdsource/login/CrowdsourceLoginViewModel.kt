package com.ai4bharat.karya.ui.crowdsource.login

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.ui.crowdsource.registration.Language

class CrowdsourceLoginViewModel : ViewModel() {

    var loginUser: MutableLiveData<LoginUser> = MutableLiveData<LoginUser>()
    var loginUserError: MutableLiveData<LoginUserError> = MutableLiveData<LoginUserError>()

    fun setData(phoneNumber: String = "", language: Language) {
        loginUser.value = LoginUser(phoneNumber, language)
    }

    fun inputValidation(): Boolean {
        val phoneNumberError: LoginError = loginUser.value!!.checkPhoneNumber()
        val tmpLoginUserError = LoginUserError(phoneNumberError)
        loginUserError.value = tmpLoginUserError
        return phoneNumberError.status
    }


    fun login() {
        val inputIsValid: Boolean = inputValidation()
        if (inputIsValid) {

        } else {
            print("Login success")
        }
    }
}