package com.ai4bharat.karya.ui.crowdsource.login

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope

class CrowdsourceLoginViewModel : ViewModel() {

    var accessCode: String? = null
    private val _accessCodeError: MutableLiveData<String> = MutableLiveData<String>()
    var loginStatus: MutableLiveData<Boolean> = MutableLiveData<Boolean>()

    val accessCodeError: LiveData<String> get() = _accessCodeError

    fun setData(accessCode: String) {
        this.accessCode = accessCode
    }

    fun setError(type: String, msg: String) {
        when (type) {
            "accessCode" -> this._accessCodeError.value = msg
        }
    }

    fun inputValidation(): Boolean {
        if (this.accessCode?.trim() == "") {
            setError("accessCode", "Empty")
            return false
        }
        return true
    }

    fun login() {
        val inputIsValid: Boolean = inputValidation()
        if (inputIsValid) {
            this.loginStatus.value = true
        } else {
            this.loginStatus.value = false
        }
        println("The access code is $accessCode")
    }
}