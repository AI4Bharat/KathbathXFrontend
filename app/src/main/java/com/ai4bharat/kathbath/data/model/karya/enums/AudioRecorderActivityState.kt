package com.ai4bharat.kathbath.data.model.karya.enums

enum class AudioRecorderActivityState {
    INIT,
    PRERECORDING,
    COMPLETED_PRERECORDING,
    RECORDING,
    RECORDED,
    FIRST_PLAYBACK,
    FIRST_PLAYBACK_PAUSED,
    COMPLETED,
    OLD_PLAYING,
    OLD_PAUSED,
    NEW_PLAYING,
    NEW_PAUSED,
    ENCODING_BACK,
    ENCODING_NEXT,
    SIMPLE_BACK,
    SIMPLE_NEXT,
    ASSISTANT_PLAYING,
    ACTIVITY_STOPPED,
}