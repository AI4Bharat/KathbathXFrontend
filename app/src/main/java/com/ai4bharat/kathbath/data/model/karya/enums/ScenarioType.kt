package com.ai4bharat.kathbath.data.model.karya.enums

enum class ScenarioType(val value: String) {
    SPEECH_DATA("SPEECH DATA"),
    SPEECH_VERIFICATION("SPEECH VERIFICATION"),
    SPEECH_DC_IMGAUD("SPEECH DATA FROM IMAGE AUDIO"),
    SPEECH_DC_AUD("SPEECH DATA FROM AUDIO"),
    SPEECH_DV_MULTI("SPEECH VERIFICATION FROM MULTI MODAL");

    override fun toString(): String {
        return value
    }
}
