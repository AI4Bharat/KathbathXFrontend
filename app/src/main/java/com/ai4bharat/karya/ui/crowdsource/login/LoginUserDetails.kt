package com.ai4bharat.karya.ui.crowdsource.login

import com.ai4bharat.karya.ui.crowdsource.registration.Language
import com.ai4bharat.karya.ui.crowdsource.registration.RegistrationError

enum class Status {
    INITIAL, LOADING, SUCCESS, FAILED
}

data class LoginStatus(val status: Status, val message: String) {
}

class LoginUser(val phoneNumber: String = "", val language: String) {

    private fun basicValidation(type: String, value: String): LoginError {
        var status: Boolean = false

        if (value.trim() == "") {
            status = true
        }
        return LoginError(type, "$type can't be empty", status)
    }


    fun checkPhoneNumber(): LoginError {
        var status = false
        var message = ""
        val type = "Phone Number"

        val basicValidationResult: LoginError = basicValidation(type, this.phoneNumber)
        if (basicValidationResult.status) {
            return basicValidationResult
        }

        val regexPattern = Regex("^[0-9]{10}\$")
        if (!regexPattern.matches(this.phoneNumber)) {
            message = "Invalid phone number"
            status = true
        }
        return LoginError(type, message, status)
    }

    fun checkLanguage(): LoginError {
        val status: Boolean
        var message = ""
        val type = "Language"
        val languageList = Language.values().map { language -> language.name }

        println("The selected language is ${this.language}")
        val basicValidationResult: LoginError = basicValidation(type, this.language)
        if (basicValidationResult.status) {
            return basicValidationResult
        }

        if (this.language in languageList) {
            status = false
        } else {
            status = true
            message = "Invalid language selected"
        }


        return LoginError(type, message, status)

    }

}

data class LoginUserError(val phoneNumberError: LoginError, val languageError: LoginError) {

}

data class LoginError(
    val type: String = "",
    val message: String = "",
    val status: Boolean = false
) {
    override fun toString(): String {
        return "$type -> $message -> $status\n "
    }
}
