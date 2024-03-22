package com.ai4bharat.karya.ui.crowdsource

enum class Gender(val displayName: String) {
    male("Male"), female("Female"), other("other")
}

enum class Education(val displayName: String) {
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
    marathi("Marathi"),
    maithili("Maithili"),
    dogri("Dogri"),
    bengali("Bengali"),
    odia("Odia"),
    kashmiri("Kashmiri"),
    sanskrit("Sanskrit"),
    assamese("Assamese"),
    malayalam("Malayalam"),
    tamil("Tamil"),
    gujarati("Gujarati"),
    bodo("Bodo"),
    nepali("Nepali"),
    konkani("Konkani"),
    telugu("Telugu"),
    santali("Santali"),
    punjabi("Punjabi"),
    hindi("Hindi"),
    sindhi("Sindhi"),
    urdu("Urdu"),
    kannada("Kannada"),
    manipuri("Manipuri")
}


data class CrowdSourceUser(
    val name: String = "",
    val age: String = "",
    val gender: Gender = Gender.male,
    val state: String = "",
    val district: String = "",
    val phoneNumber: String = "",
    val jobType: JobType = JobType.white_collar,
    val education: Education = Education.no_schooling,
    val occupation: String = "",
    val language: Language = Language.hindi

) {
    override fun toString(): String {
        return "Name ${name}, age ${age}, gender ${gender}, state ${state} , district ${district}"
    }
}

