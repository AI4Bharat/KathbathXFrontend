package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import dagger.hilt.android.AndroidEntryPoint
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel

@AndroidEntryPoint
class SpeechAudioDataFragment : BaseMTRendererFragment(R.layout.microtask_speech_audio_data) {

    override val viewModel: SpeechAudioDataViewModel by viewModels()
    val args: SpeechAudioDataFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        viewModel.setupViewModel(args.taskId, args.completed, args.total)
        return super.onCreateView(inflater, container, savedInstanceState)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewModel.setupSpeechDataViewModel()
    }

}