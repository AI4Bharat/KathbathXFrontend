package com.ai4bharat.karya.ui.crowdsource

data class CrowdSourceUser(
    val userName: String = "",
    val age: String = "",
    val gender: String = "",
    val state: String = "",
    val district: String = ""
) {
    override fun toString(): String {
        return "User name ${userName}, age ${age}, gender ${gender}, state ${state} , district ${district}"
    }
}

