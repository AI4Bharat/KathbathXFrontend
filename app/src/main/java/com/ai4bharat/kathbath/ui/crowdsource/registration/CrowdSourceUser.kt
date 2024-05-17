package com.ai4bharat.kathbath.ui.crowdsource.registration

import com.ai4bharat.kathbath.ui.crowdsource.login.Status

enum class MostTimeSpend(val displayName: String) {
    city("City"), big_town("Big Town"), small_town("Small Town"), village("Village")
}

enum class Gender(val displayName: String) {
    male("Male"), female("Female"), other("Other")
}

data class RegistrationStatus(var status: Status, var message: String) {
}

enum class HighestQualification(val displayName: String) {
    no_schooling("No Schooling"),
    high_school("Higher Secondary Level at School (10th)"),
    senior_high_school("Senior Secondary Level at School (10+2)"),
    diploma("Diploma Holder"),
    ug("Under Graduate Student"),
    graduate("Graduate"),
    post_graduate("Post Graduate"),
    doctoral("Doctoral (PhD) or higher level")
}

enum class JobType(val displayName: String) {
    blue_collar("Blue Collar"), white_collar("White Collar"), student("Student"), unemployed("Unemployed")
}

enum class Language(val displayName: String) {
    assamese("Assamese"),
    bengali("Bengali"),
    bodo("Bodo"),
    dogri("Dogri"),
    gujarati("Gujarati"),
    hindi("Hindi"),
    kannada("Kannada"),
    kashmiri("Kashmiri"),
    konkani("Konkani"),
    maithili("Maithili"),
    malayalam("Malayalam"),
    manipuri("Manipuri"),
    marathi("Marathi"),
    nepali("Nepali"),
    odia("Odia"),
    punjabi("Punjabi"),
    sanskrit("Sanskrit"),
    santali("Santali"),
    sindhi("Sindhi"),
    tamil("Tamil"),
    telugu("Telugu"),
    urdu("Urdu")
}

data class State(val key: String, val name: String, var district: List<District>) {
    override fun toString(): String {
        return "The state is $key -> $name with district ${district.joinToString()}"
    }
}

data class District(val key: String, val name: String) {
    override fun toString(): String {
        return name
    }
}


class CrowdSourceUser(
    val name: String = "",
    val age: String = "",
    val gender: String = "",
    val state: String = "",
    val district: String = "",
    val phoneNumber: String = "",
    val jobType: String = "",
    val highestQualification: String = "",
    val occupation: String = "",
    val language: String = "",
    val acceptConsent: Boolean = true,
    val referralCode: String? = "",
    val mostTimeSpend: String = ""

) {
    override fun toString(): String {
        return "Name ${name}, age ${age}, gender ${gender}, state ${state} , district ${district}," +
                "Phone number ${phoneNumber}, Job Type ${jobType}, Education ${highestQualification}" +
                "Occupation ${occupation}, Language ${language} Consent form -> $acceptConsent, Most time spend -> ${mostTimeSpend}"
    }

    fun basicValidation(type: String, value: String): RegistrationError {
        var status: Boolean = false

        if (value.trim() == "") {
            status = true
        }
        return RegistrationError(type, "$type can't be empty", status)
    }

    fun checkReferralCode(): RegistrationError {
        val status = false
        val message = ""
        val type = "Referral Code"
        if (this.referralCode == null || this.referralCode == "")
            return RegistrationError(type, message, status)
        return basicValidation(type, this.referralCode)
    }

    // Since occupation and name have similar regex pattern we could combine them
    fun checkNameAndOccupation(type: String = "Name"): RegistrationError {
        var status = false
        var message = ""
        val value = if (type == "Name") this.name else this.occupation
        val basicValidationResult: RegistrationError = basicValidation(type, value)

        if (basicValidationResult.status) {
            return basicValidationResult
        }

        val regexPattern = Regex("^[A-Za-z]?([A-Za-z] ?)+$")
        if (!regexPattern.matches(value)) {
            message = "Invalid $type"
            status = true
        } else {
            message = ""
            status = false
        }
        return RegistrationError(type, message, status)
    }

    fun checkPhoneNumber(): RegistrationError {
        var status = false
        var message = ""
        val type = "Phone number"

        val basicValidationResult: RegistrationError = basicValidation(type, this.phoneNumber)
        if (basicValidationResult.status) {
            return basicValidationResult
        }

        val regexPattern = Regex("^[0-9]{10}\$")
        if (!regexPattern.matches(this.phoneNumber)) {
            message = "Invalid phone number"
            status = true
        }
        return RegistrationError(type, message, status)
    }

    fun checkAge(): RegistrationError {
        var status = false
        var message: String = ""
        val type = "Age"

        val basicValidationResult: RegistrationError = basicValidation(type, this.age)
        if (basicValidationResult.status) {
            return basicValidationResult
        }

        val regexPattern = Regex("(^[0-9]{1,2}\$)|(^1[0-1][0-9])")
        if (!regexPattern.matches(this.age)) {
            message = "Invalid age"
            status = true
        } else {
            if (this.age.toInt() < 18) {
                message = "Should be at least 18 years old"
                status = true
            }
        }
        return RegistrationError(type, message, status)
    }

    // For verifying values like gender, job, education and language
    fun checkPreDefinedVariable(
        type: String
    ): RegistrationError {
        var status = false
        var message = ""
        var selectedValue = ""
        var possibleValues: List<String> = listOf()
        when (type) {
            "Gender" -> {
                possibleValues = Gender.values()
                    .map { value -> value.name }
                selectedValue = this.gender
            }

            "Job Type" -> {
                possibleValues = JobType.values().map { value -> value.name }
                selectedValue = this.jobType
            }

            "Education" -> {
                possibleValues = HighestQualification.values().map { value -> value.name }
                selectedValue = this.highestQualification
            }

            "Language" -> {
                possibleValues = Language.values().map { value -> value.name }
                selectedValue = this.language
            }

            "Most Time Spend" -> {
                possibleValues = MostTimeSpend.values().map { value -> value.name }
                selectedValue = this.mostTimeSpend
            }
        }
        println("$type, $possibleValues ${this.mostTimeSpend}")
        val basicValidationResult: RegistrationError = basicValidation(type, selectedValue)
        if (basicValidationResult.status) {
            return basicValidationResult
        }
        selectedValue = selectedValue.replace(" ", "_").lowercase()
        if (!possibleValues.contains(selectedValue)) {
            message = "$type is invalid"
            status = true
        }
        return RegistrationError(type, message, status)
    }

    fun checkConsentAcceptance(): RegistrationError {
        var status = false
        var message = ""
        if (!this.acceptConsent) {
            status = true
            message = "Please read and accept the consent form"
        }
        return RegistrationError("acceptConsent", message, status)
    }

    fun checkState(locationInfo: MutableList<State>?): RegistrationError {
        var status = false
        var message = ""
        val type = "State"
        val value = this.state.lowercase()
        val basicValidationResult: RegistrationError =
            basicValidation("State", value)
        if (basicValidationResult.status) {
            return basicValidationResult
        }


        val stateList: List<String> = locationInfo!!.map { state -> state.name.lowercase() }
        println("State checker $stateList")
        if (!stateList.contains(value)) {
            status = true
            message = "State is invalid"
        }
        println("State checker $basicValidationResult")
        return RegistrationError(type, message, status)
    }

    fun checkDistrict(locationInfo: MutableList<State>?): RegistrationError {
        var status = false
        var message = ""
        val type = "District"
        val value = this.district.lowercase()
        val basicValidationResult: RegistrationError =
            basicValidation("District", value)
        if (basicValidationResult.status) {
            return basicValidationResult
        }
        val stateInfo: List<State> =
            locationInfo!!.filter { state -> state.name == this.state }
        if (stateInfo.isNotEmpty()) {
            val districtList = stateInfo[0].district.map { district -> district.name.lowercase() }
            if (!districtList.contains(value)) {
                status = true
                message = "Invalid district selected"
            }
        } else {
            status = true
            message = "Please select a valid State first"

        }
        return RegistrationError(type, message, status)
    }

}

class CrowdSourceUserError(
    var name: RegistrationError = RegistrationError("Name", "", false),
    val age: RegistrationError = RegistrationError("Age", "", false),
    val gender: RegistrationError = RegistrationError("Gender", "", false),
    val state: RegistrationError = RegistrationError("State", "", false),
    val district: RegistrationError = RegistrationError("District", "", false),
    val phoneNumber: RegistrationError = RegistrationError("Phone Number", "", false),
    val jobType: RegistrationError = RegistrationError("Job Type", "", false),
    val education: RegistrationError = RegistrationError("Education", "", false),
    val occupation: RegistrationError = RegistrationError("Occupation", "", false),
    val language: RegistrationError = RegistrationError("Language", "", false),
    var acceptConsent: RegistrationError = RegistrationError("Accept Consent", "", false),
    val referralCode: RegistrationError = RegistrationError("Referral Code", "", false),
    val mostTimeSpend: RegistrationError = RegistrationError("Most Time Spend", "", false)
) {
    override fun toString(): String {
        return "name $name age $age gender $gender" +
                "state $state district $district phoneNumber $phoneNumber" +
                "jobType $jobType education $education occupation $occupation" +
                "language $language consent $acceptConsent"

    }

    // Checks if any of the parameters are false. True means there is some issue
    fun errorExist(): Boolean {
        return name.status || age.status || gender.status || state.status || district.status
                || phoneNumber.status || jobType.status || education.status || occupation.status
                || language.status || acceptConsent.status

    }

}

data class RegistrationError(
    val type: String = "",
    val message: String = "",
    val status: Boolean = false
) {
    override fun toString(): String {
        return "$type -> $message -> $status\n"
    }
}
