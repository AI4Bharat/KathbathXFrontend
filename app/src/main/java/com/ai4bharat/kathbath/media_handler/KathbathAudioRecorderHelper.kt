package com.ai4bharat.kathbath.media_handler

import android.annotation.SuppressLint
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder

private const val SAMPLING_RATE = 44100
private const val AUDIO_CHANNEL = AudioFormat.CHANNEL_IN_MONO
private const val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT

//@SuppressLint("MissingPermission")
class KathbathAudioRecorderHelper() {

    private val audioRecorder: AudioRecord
    private val _minBufferSize = AudioRecord.getMinBufferSize(
        SAMPLING_RATE,
        AUDIO_CHANNEL, AUDIO_FORMAT
    )

    val _recorderBufferSize = _minBufferSize * 4

    init {
        audioRecorder = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            SAMPLING_RATE,
            AUDIO_CHANNEL,
            AUDIO_FORMAT,
            _recorderBufferSize
        )
        println("THE CALLED $_minBufferSize $audioRecorder")
    }

    fun getAudioRecorder(): AudioRecord {
        return audioRecorder
    }

}