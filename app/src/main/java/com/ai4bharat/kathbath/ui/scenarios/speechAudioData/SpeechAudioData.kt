package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.ai4bharat.kathbath.R

class SpeechAudioData : Fragment() {

    companion object {
        fun newInstance() = SpeechAudioData()
    }

    private val viewModel: SpeechAudioDataViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // TODO: Use the ViewModel
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.microtask_speech_audio_data, container, false)
    }
}