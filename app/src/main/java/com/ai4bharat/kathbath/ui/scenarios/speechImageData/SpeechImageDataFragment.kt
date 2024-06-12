package com.ai4bharat.kathbath.ui.scenarios.speechImageData

import android.media.MediaPlayer
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecordingState
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.kathbath.utils.extensions.viewLifecycle
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.fragment_speech_image_data.speechImageRecordButton
import kotlinx.android.synthetic.main.fragment_speech_image_data.speechImageReplayButton
import kotlinx.android.synthetic.main.fragment_speech_image_data.textView11


@AndroidEntryPoint
class SpeechImageDataFragment : BaseMTRendererFragment(R.layout.fragment_speech_image_data) {

    override val viewModel: SpeechImageDataViewModel by viewModels()
    val args: SpeechImageDataFragmentArgs by navArgs()


    private lateinit var updateAudioProgress: Runnable
    private val handler = Handler(Looper.getMainLooper())


    private val TAG = "Speech Image"

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = super.onCreateView(inflater, container, savedInstanceState)
        println("Setting up view model one")
        viewModel.setupViewModel(args.taskId, args.completed, args.total)
        println("Setting up view model one one")
        requireActivity().window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupUI()
    }

    private fun setupUI() {

        with(viewModel) {
            recordingStatus.observe(viewLifecycleOwner) {
                if (it == AudioRecordingState.RECORDING) {
                    speechImageRecordButton.text = "Stop Recording"
                } else {
                    speechImageRecordButton.text = "Start Recording"
                }
            }


            recordedDuration.observe(viewLifecycleOwner, Observer {
                textView11.text = it.toString()
            })
        }



        speechImageRecordButton.setOnClickListener {
            viewModel.startRecording()
        }

        speechImageReplayButton.setOnClickListener {
            viewModel.finishAndSaveRecording()
        }


//        val audioPlayingObserver = Observer<Boolean> {
//            if (it) {
//                binding.speechImagePlayPauseButton.text = "Pause"
//            } else {
//                binding.speechImagePlayPauseButton.text = "Play"
//            }
//        }
//        viewModel.inputAudioPlaying.observe(viewLifecycleOwner, audioPlayingObserver)

//        binding.speechImagePlayPauseButton.setOnClickListener {
//            if (viewModel.inputAudioPlaying.value == true) {
//                mediaPlayer.pause()
//                viewModel.audioPlayerStatus(false)
//            } else {
//                mediaPlayer.start()
//                viewModel.audioPlayerStatus(true)
//            }
//            Log.d(
//                TAG,
//                "Media Player status ${mediaPlayer.isPlaying} ${viewModel.inputAudioPlaying.value}"
//            )
//        }
//        initializeSeekbar(mediaPlayer)
//        audioPlayer.setOnPreparedListener {
//            it.start()
//            println("SEEK ${it.isPlaying}")
//        }
//
//        with(binding) {
//            speechImagePlayPauseButton.setOnClickListener {
////                audioPlayer.start()
//            }
//        }
    }

//    private fun initializeSeekbar(mediaPlayer: MediaPlayer) {
//        updateAudioProgress = Runnable {
//            speechImageSpeechProgressBar.progress = mediaPlayer.currentPosition
//            handler.postDelayed(updateAudioProgress, 1000)
//        }
//        updateAudioProgress.run()
//    }
}
















