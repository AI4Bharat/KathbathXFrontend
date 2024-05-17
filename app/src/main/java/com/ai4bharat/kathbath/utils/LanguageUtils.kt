package com.ai4bharat.kathbath.utils

object LanguageUtils {

    private val languageMap: Map<String, String> = mapOf(
        "PA" to "Punjabi",
        "UR" to "Urdu",
        "SD" to "Sindhi",
        "MNI" to "Manipuri",
        "DOI" to "Dogri",
        "BRX" to "Bodo",
        "MAI" to "Maithili",
        "SA" to "Sanskrit",
        "KS" to "Kashmiri",
        "NE" to "Nepali",
        "TE" to "Telugu",
        "AS" to "Assamese",
        "BN" to "Bengali",
        "OR" to "Odia",
        "GUJ" to "Gujarati",
        "MR" to "Marathi",
        "KN" to "Kannada",
        "KOK" to "Konkani",
        "HI" to "Hindi",
        "ML" to "Malayalam",
        "SAT" to "Santali",
        "TA" to "Tamil"
    )

    fun getLanguageFromCode(languageCode: String): String {
        return if (languageCode in languageMap) {
            languageMap[languageCode]!!
        } else {
            ""
        }
    }

}