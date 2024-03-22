package com.ai4bharat.karya.ui.crowdsource.registration

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.ui.crowdsource.CrowdSourceUser
import com.ai4bharat.karya.ui.crowdsource.Education
import com.ai4bharat.karya.ui.crowdsource.Gender
import com.ai4bharat.karya.ui.crowdsource.JobType
import com.ai4bharat.karya.ui.crowdsource.Language
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow

class CrowdsourceRegistrationViewModel : ViewModel() {

    var user: CrowdSourceUser? = null

    fun setData(
        name: String,
        age: String,
        phoneNumber: String,
        gender: Gender,
        state: String = "",
        district: String = "",
        jobType: JobType,
        education: Education,
        occupation: String,
        language: Language,
    ) {
        user = CrowdSourceUser(
            name,
            age,
            gender,
            state,
            district,
            phoneNumber,
            jobType,
            education,
            occupation,
            language
        )
        submitRegistrationData()
    }

    private fun submitRegistrationData() {
        println(user)
    }
}