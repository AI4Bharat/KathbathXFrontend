package com.ai4bharat.kathbath.data.model.karya.enums

enum class ScenarioType(val value: String) {
    SPEECH_DATA("SPEECH DATA"),
    SPEECH_VERIFICATION("SPEECH VERIFICATION"),
    SPEECH_DATA_FROM_IMAGE_AUDIO("SPEECH DATA FROM IMAGE AUDIO"),
    SPEECH_DATA_FROM_AUDIO("SPEECH DATA FROM AUDIO"),
    SPEECH_VERIFICATION_IMAGE_AUDIO("SPEECH VERIFICATION FROM IMAGE AUDIO");

    override fun toString(): String {
        return value
    }
}
