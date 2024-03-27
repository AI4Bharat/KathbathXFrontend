package com.ai4bharat.karya.ui.crowdsource.registration

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import org.json.JSONObject

class CrowdsourceRegistrationViewModel() : ViewModel() {

    var user: CrowdSourceUser? = null
    var userError: MutableLiveData<CrowdSourceUserError> = MutableLiveData<CrowdSourceUserError>()
    var location: MutableLiveData<MutableList<State>> =
        MutableLiveData<MutableList<State>>()

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

    fun initializeLocation(locationInfo: JSONObject) {
        val stateKeys = locationInfo.names()
        val stateList: MutableList<State> = mutableListOf()
        if (stateKeys != null) {
            for (key in 0 until stateKeys.length()) {
                val stateKey = stateKeys[key].toString()
                val stateInfo: JSONObject = locationInfo.getJSONObject(stateKey)
                val stateName: String = stateInfo.get("name").toString()
                val districtInfoObject: JSONObject = stateInfo.getJSONObject("district")
                val tmpDistrictList: MutableList<District> = mutableListOf()
                for (key in 0 until districtInfoObject.names().length()) {
                    val districtKey: String = districtInfoObject.names()[key].toString()
                    val districtInfo: JSONObject = districtInfoObject.getJSONObject(districtKey)
                    val districtName: String = districtInfo.get("name").toString()
                    val tmpDistrict: District = District(districtKey, districtName)
                    tmpDistrictList.add(tmpDistrict)
                }
                stateList.add(State(stateKey, stateName, tmpDistrictList))
            }
        } else {
            print("District keys are empty")
        }

        location.value = stateList;
    }

    private fun submitRegistrationData() {
        validateInputs()
        println(user)
    }

    private fun validateInputs() {
        val nameError: RegistrationError = user!!.checkNameAndOccupation("name")
        val occupationError: RegistrationError = user!!.checkNameAndOccupation("occupation")
        val ageError: RegistrationError = user!!.checkAge()
        val genderError: RegistrationError = user!!.checkPreDefinedVariable("gender")
        val stateError: RegistrationError = user!!.checkState(location.value)
        val districtError: RegistrationError = user!!.checkDistrict(location.value)
        val phoneNumberError: RegistrationError = user!!.checkPhoneNumber()
        val jobTypeError: RegistrationError = user!!.checkPreDefinedVariable("jobType")
        val educationError: RegistrationError = user!!.checkPreDefinedVariable("education")
        val languageError: RegistrationError = user!!.checkPreDefinedVariable("language")
        val crowdSourceUserError: CrowdSourceUserError = CrowdSourceUserError(
            name = nameError,
            age = ageError,
            gender = genderError,
            state = stateError,
            district = districtError,
            phoneNumber = phoneNumberError,
            jobType = jobTypeError,
            education = educationError,
            occupation = occupationError,
            language = languageError
        )
        userError.value = crowdSourceUserError
    }


}