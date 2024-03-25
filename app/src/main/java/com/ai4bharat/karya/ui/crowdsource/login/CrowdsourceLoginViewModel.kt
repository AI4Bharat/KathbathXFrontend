package com.ai4bharat.karya.ui.crowdsource.login

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class CrowdsourceLoginViewModel : ViewModel() {

    var accessCode: String? = null
    private val _accessCodeError: MutableLiveData<String> = MutableLiveData<String>()

    val accessCodeError: LiveData<String> get() = _accessCodeError

    fun setData(accessCode: String) {
        this.accessCode = accessCode
    }

    fun setError(type: String, msg: String) {
        when (type) {
            "accessCode" -> this._accessCodeError.value = msg
        }
    }

    fun inputValidation() {
        if (this.accessCode?.trim() == "") {
            setError("accessCode", "Empty")
        }
    }

    fun login() {
        inputValidation()
        println("The access code is $accessCode")
    }
}