package com.ai4bharat.karya.ui.crowdsource.registration

import com.ai4bharat.karya.ui.crowdsource.login.Status

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
    val gender: Gender = Gender.male,
    val state: String = "",
    val district: String = "",
    val phoneNumber: String = "",
    val jobType: JobType = JobType.white_collar,
    val highestQualification: HighestQualification = HighestQualification.no_schooling,
    val occupation: String = "",
    val language: Language = Language.hindi,
    val acceptConsent: Boolean = true

) {
    override fun toString(): String {
        return "Name ${name}, age ${age}, gender ${gender}, state ${state} , district ${district}," +
                "Phone number ${phoneNumber}, Job Type ${jobType}, Education ${highestQualification}" +
                "Occupation ${occupation}, Language ${language}"
    }

    fun basicValidation(type: String, value: String): RegistrationError {
        var status: Boolean = false

        if (value.trim() == "") {
            status = true
        }
        println("Inside basic validation $type ${value.trim()}")
        return RegistrationError(type, "$type can't be empty", status)
    }

    // Since occupation and name have similar regex pattern we could combine them
    fun checkNameAndOccupation(type: String = "name"): RegistrationError {
        var status = false
        var message = ""
        val value = if (type == "name") this.name else this.occupation
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
        val type = "phoneNumber"

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
        var message = ""
        val type = "name"

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
            "gender" -> {
                possibleValues = Gender.values()
                    .map { t -> t.name.replaceFirstChar { char -> char.uppercase() } }
                selectedValue = this.gender.name
            }

            "jobType" -> {
                possibleValues = Gender.values().map { value -> value.name }
                selectedValue = this.jobType.name
            }

            "education" -> {
                possibleValues = Gender.values().map { value -> value.name }
                selectedValue = this.highestQualification.name
            }

            "language" -> {
                possibleValues = Gender.values().map { value -> value.name }
                selectedValue = this.language.name

            }
        }
        val basicValidationResult: RegistrationError = basicValidation(type, selectedValue)
        if (basicValidationResult.status) {
            return basicValidationResult
        }
        if (possibleValues.contains(selectedValue)) {
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
        val type = "state"
        val basicValidationResult: RegistrationError =
            basicValidation("state", this.state)
        if (basicValidationResult.status) {
            return basicValidationResult
        }

        println("State checker $basicValidationResult")

        val stateList: List<String> = locationInfo!!.map { state -> state.name }
        if (!stateList.contains(this.state)) {
            status = true
            message = "State is invalid"
        }
        println("State checker $basicValidationResult")
        return RegistrationError(type, message, status)
    }

    fun checkDistrict(locationInfo: MutableList<State>?): RegistrationError {
        var status = false
        var message = ""
        val type = "district"
        val basicValidationResult: RegistrationError =
            basicValidation("district", this.district)
        if (basicValidationResult.status) {
            return basicValidationResult
        }
        val stateInfo: List<State> =
            locationInfo!!.filter { state -> state.name == this.state }
        if (stateInfo.size > 0) {
            val districtList = stateInfo[0].district.map { district -> district.name }
            if (!districtList.contains(this.district)) {
                status = true
                message = "District is invalid"
            }
        } else {
            status = true
            message = "State is invalid"

        }
        return RegistrationError(type, message, status)
    }

}

class CrowdSourceUserError(
    var name: RegistrationError = RegistrationError("name", "", false),
    val age: RegistrationError = RegistrationError("age", "", false),
    val gender: RegistrationError = RegistrationError("gender", "", false),
    val state: RegistrationError = RegistrationError("state", "", false),
    val district: RegistrationError = RegistrationError("district", "", false),
    val phoneNumber: RegistrationError = RegistrationError("phoneNumber", "", false),
    val jobType: RegistrationError = RegistrationError("jobType", "", false),
    val education: RegistrationError = RegistrationError("education", "", false),
    val occupation: RegistrationError = RegistrationError("occupation", "", false),
    val language: RegistrationError = RegistrationError("language", "", false),
    val acceptConsent: RegistrationError = RegistrationError("acceptConsent", "", false)
) {
    override fun toString(): String {
        return "name $name age $age gender $gender" +
                "state $state distrct $district phoneNumber $phoneNumber" +
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
