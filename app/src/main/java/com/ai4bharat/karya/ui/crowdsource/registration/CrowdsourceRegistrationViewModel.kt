package com.ai4bharat.karya.ui.crowdsource.registration

import android.widget.Toast
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.manager.BaseUrlManager
import com.ai4bharat.karya.data.model.karya.WorkerRecord
import com.ai4bharat.karya.data.repo.WorkerRepository
import com.ai4bharat.karya.ui.crowdsource.login.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.onStart
import org.json.JSONObject
import javax.inject.Inject

@HiltViewModel
class CrowdsourceRegistrationViewModel
@Inject
constructor(
    private val workerRepository: WorkerRepository,
    private val authManager: AuthManager,
    private val baseUrlManager: BaseUrlManager
) : ViewModel() {

    var user: MutableLiveData<CrowdSourceUser> = MutableLiveData<CrowdSourceUser>()
    var userError: MutableLiveData<CrowdSourceUserError> = MutableLiveData<CrowdSourceUserError>()
    var location: MutableLiveData<MutableList<State>> =
        MutableLiveData<MutableList<State>>()
    var registrationStatus: MutableLiveData<RegistrationStatus> =
        MutableLiveData<RegistrationStatus>(RegistrationStatus(Status.INITIAL, ""))

    fun setData(
        name: String = "",
        age: String = "",
        phoneNumber: String = "",
        gender: String = "",
        state: String = "",
        district: String = "",
        jobType: String = "",
        highestQualification: String = "",
        occupation: String = "",
        language: String = "",
        acceptConsent: Boolean = false,
        referralCode: String = ""
    ) {
        user.value = CrowdSourceUser(
            name,
            age,
            gender,
            state,
            district,
            phoneNumber,
            jobType,
            highestQualification,
            occupation,
            language,
            acceptConsent,
            referralCode
        )
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

    fun submitRegistrationData() {

        val tmpWorker = CrowdSourceUser(
            "Crowd tester", "38", Gender.male.name,
            "jammu_kashmir",
            "anantnag",
            "0001551000",
            JobType.blue_collar.name,
            HighestQualification.no_schooling.name,
            "Farmer",
            Language.kashmiri.name,
            true,
            referalCode = "LJP"
        )


//        if (!validateInputs() || true) {
        if (true) {
            println(this.user.value)
            workerRepository.createNewWorker(tmpWorker)
//            workerRepository.createNewWorker(this.user.value!!)
                .onStart {
                    println("User registration starting")
                    registrationStatus.value = RegistrationStatus(Status.LOADING, "")
                }.onEach {
                    println("The access code is $it")
                    registrationStatus.value = it
                }.catch {
                    println("The error in registration is $it")
                    registrationStatus.value =
                        RegistrationStatus(Status.FAILED, "Registration Failed")
                }
                .launchIn(viewModelScope)
        } else {
            println("Error in input data")
        }
    }

    private fun validateInputs(): Boolean {
        var status = false;
        val nameError: RegistrationError = user.value!!.checkNameAndOccupation("Name")
        val occupationError: RegistrationError = user.value!!.checkNameAndOccupation("Occupation")
        val ageError: RegistrationError = user.value!!.checkAge()
        val genderError: RegistrationError = user.value!!.checkPreDefinedVariable("Gender")
        val stateError: RegistrationError = user.value!!.checkState(location.value)
        val districtError: RegistrationError = user.value!!.checkDistrict(location.value)
        val phoneNumberError: RegistrationError = user.value!!.checkPhoneNumber()
        val jobTypeError: RegistrationError = user.value!!.checkPreDefinedVariable("Job Type")
        val educationError: RegistrationError = user.value!!.checkPreDefinedVariable("Education")
        val languageError: RegistrationError = user.value!!.checkPreDefinedVariable("Language")
        val referralCodeError: RegistrationError = user.value!!.checkReferalCode()
        val consentAcceptError: RegistrationError = user.value!!.checkConsentAcceptance()
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
            language = languageError,
            acceptConsent = consentAcceptError,
            referralCode = referralCodeError
        )
        userError.value = crowdSourceUserError
        return userError.value!!.errorExist()
    }


}