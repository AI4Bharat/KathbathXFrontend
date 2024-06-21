package com.ai4bharat.kathbath.media_handler

import android.content.Context
import android.media.MediaPlayer
import androidx.lifecycle.MutableLiveData

class KathbathAudioPlayerHelper(context: Context, audioFilePath: Int) {

    private var mediaPlayer: MediaPlayer = MediaPlayer.create(context, audioFilePath)
    var audioLength: Int = 0
    var currentTime: MutableLiveData<Int> = MutableLiveData<Int>()
    var audioPlaying: MutableLiveData<Boolean> = MutableLiveData<Boolean>()

//    init {
//    }

    fun getMediaPlayer(): MediaPlayer {
        return mediaPlayer
    }

//    fun start() {
//        mediaPlayer.start()
//    }
//
//    fun stop() {
//        mediaPlayer.stop()
//    }

}