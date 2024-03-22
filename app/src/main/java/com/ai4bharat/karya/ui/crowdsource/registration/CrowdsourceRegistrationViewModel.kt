package com.ai4bharat.karya.ui.crowdsource.registration

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.ui.crowdsource.CrowdSourceUser
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow

class CrowdsourceRegistrationViewModel : ViewModel() {

    var user: CrowdSourceUser? = null

    fun setData(
        name: String,
        age: String,
        gender: String,
        state: String = "",
        district: String = ""
    ) {
        user = CrowdSourceUser(name, age, gender, state, district)
        submitRegistrationData()
    }

    private fun submitRegistrationData() {
        println(user)
    }
}