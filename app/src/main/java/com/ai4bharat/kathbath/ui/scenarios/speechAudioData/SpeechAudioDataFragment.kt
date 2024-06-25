package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import android.app.AlertDialog
import android.graphics.Color
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.activity.addCallback
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import dagger.hilt.android.AndroidEntryPoint
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.AssistantAudio
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderActivityState
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.utils.extensions.invisible
import com.ai4bharat.kathbath.utils.extensions.observe
import com.ai4bharat.kathbath.utils.extensions.viewLifecycleScope
import com.ai4bharat.kathbath.utils.extensions.visible
import kotlinx.android.synthetic.main.microtask_common_back_button.view.backIv
import kotlinx.android.synthetic.main.microtask_common_next_button.view.nextIv
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioBackButton
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_1
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_1CurrentTime
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_1TotalTime
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_2
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_2CurrentTime
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioPlayButton_2TotalTime
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioProgressBar_1
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioInputAudioProgressBar_2
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioNextButton
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioPlayButton
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioRecordButton
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudioplaybackProgressPb
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudiorecordCentiSecondsTv
import kotlinx.android.synthetic.main.microtask_speech_audio_data.microtaskSpeechAudiorecordSecondsTv
import kotlinx.android.synthetic.main.microtask_speech_image_data.backPointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.nextPointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.playPointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.playbackProgressPb
import kotlinx.android.synthetic.main.microtask_speech_image_data.recordCentiSecondsTv
import kotlinx.android.synthetic.main.microtask_speech_image_data.recordPointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.recordSecondsTv
import kotlinx.android.synthetic.main.microtask_speech_image_data.sentencePointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageBackButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageNextButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImagePlayButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageRecordButton
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@AndroidEntryPoint
class SpeechAudioDataFragment : BaseMTRendererFragment(R.layout.microtask_speech_audio_data) {

    override val viewModel: SpeechAudioDataViewModel by viewModels()
    val args: SpeechAudioDataFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = super.onCreateView(inflater, container, savedInstanceState)
        viewModel.setupViewModel(args.taskId, args.completed, args.total)
        requireActivity().window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupListener()
        viewModel.setupSpeechDataViewModel()
        setupObservables()
        setupUI()
        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) { viewModel.onBackPressed() }
    }

    private fun setupObservables() {

        viewModel.inputAudioPlayerOneTimestamp.observe(viewLifecycleOwner) {
            microtaskSpeechAudioInputAudioPlayButton_1CurrentTime.text = it.first
            microtaskSpeechAudioInputAudioPlayButton_1TotalTime.text = it.second
        }
        viewModel.inputAudioPlayerTwoTimestamp.observe(viewLifecycleOwner) {
            microtaskSpeechAudioInputAudioPlayButton_2CurrentTime.text = it.first
            microtaskSpeechAudioInputAudioPlayButton_2TotalTime.text = it.second
        }
        viewModel.inputAudioPlayerOneState.observe(
            viewLifecycleOwner
        ) { state ->
            println("MADD state one $state")
            when (state) {
                InputAudioPlayerState.PLAYING -> microtaskSpeechAudioInputAudioPlayButton_1.setBackgroundResource(
                    R.drawable.baseline_pause_circle_outline_24
                )

                else -> {
                    microtaskSpeechAudioInputAudioPlayButton_1.setBackgroundResource(R.drawable.baseline_play_circle_outline_24)
                }
            }
        }

        viewModel.inputAudioPlayerTwoState.observe(
            viewLifecycleOwner,
        ) { state ->
            println("MADD state two $state")
            when (state) {
                InputAudioPlayerState.PLAYING -> microtaskSpeechAudioInputAudioPlayButton_2.setBackgroundResource(
                    R.drawable.baseline_pause_circle_outline_24
                )

                else -> {
                    microtaskSpeechAudioInputAudioPlayButton_2.setBackgroundResource(R.drawable.baseline_play_circle_outline_24)
                }
            }
        }

        viewModel.inputAudioPlayerOneTime.observe(viewLifecycleOwner) { progress ->
            microtaskSpeechAudioInputAudioProgressBar_1.progress = progress
        }
        viewModel.inputAudioPlayerTwoTime.observe(viewLifecycleOwner) { progress ->
            microtaskSpeechAudioInputAudioProgressBar_2.progress = progress
        }


        viewModel.backBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            microtaskSpeechAudioBackButton.isClickable =
                state != AudioRecorderButtonState.DISABLED
            microtaskSpeechAudioBackButton.backIv.setBackgroundResource(
                when (state) {
                    AudioRecorderButtonState.DISABLED -> R.drawable.ic_back_disabled
                    AudioRecorderButtonState.ENABLED -> R.drawable.ic_back_enabled
                    AudioRecorderButtonState.ACTIVE -> R.drawable.ic_back_enabled
                }
            )
        }

        viewModel.recordBtnState.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { state ->
            microtaskSpeechAudioRecordButton.isClickable =
                state != AudioRecorderButtonState.DISABLED
            if (viewModel.extempore) {
                microtaskSpeechAudioRecordButton.setBackgroundResource(R.drawable.button_upload_foreground)
                return@observe
            }
            microtaskSpeechAudioRecordButton.setBackgroundResource(
                when (state) {
                    AudioRecorderButtonState.DISABLED -> R.drawable.ic_mic_disabled
                    AudioRecorderButtonState.ENABLED -> R.drawable.ic_mic_enabled
                    AudioRecorderButtonState.ACTIVE -> R.drawable.ic_mic_active
                }
            )
        }

        viewModel.playBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            microtaskSpeechAudioPlayButton.isClickable =
                state != AudioRecorderButtonState.DISABLED
            microtaskSpeechAudioPlayButton.setBackgroundResource(
                when (state) {
                    AudioRecorderButtonState.DISABLED -> R.drawable.ic_speaker_disabled
                    AudioRecorderButtonState.ENABLED -> R.drawable.ic_speaker_enabled
                    AudioRecorderButtonState.ACTIVE -> R.drawable.ic_speaker_active
                }
            )
        }

        viewModel.nextBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            microtaskSpeechAudioNextButton.isClickable =
                state != AudioRecorderButtonState.DISABLED
            microtaskSpeechAudioNextButton.nextIv.setBackgroundResource(
                when (state) {
                    AudioRecorderButtonState.DISABLED -> R.drawable.ic_next_disabled
                    AudioRecorderButtonState.ENABLED -> R.drawable.ic_next_enabled
                    AudioRecorderButtonState.ACTIVE -> R.drawable.ic_next_enabled
                }
            )
        }

        viewModel.recordSecondsTvText.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { text ->
            microtaskSpeechAudiorecordSecondsTv.text = text
        }

        viewModel.recordCentiSecondsTvText.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { text ->
            microtaskSpeechAudiorecordCentiSecondsTv.text = text
        }

        viewModel.playbackProgressPb.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { progress ->
            microtaskSpeechAudioplaybackProgressPb.progress = progress
        }

        viewModel.playbackProgressPbMax.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { max ->
            microtaskSpeechAudioplaybackProgressPb.max = max
        }

        viewModel.playRecordPromptTrigger.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { play ->
            if (play) {
                playRecordPrompt()
            }
        }

        viewModel.skipTaskAlertTrigger.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { showAlert ->
            if (showAlert) {
                val builder = AlertDialog.Builder(requireContext())
                builder.setCancelable(false)
                val message = getString(R.string.skip_task_warning)
                builder.setMessage(message)
                builder.setPositiveButton(R.string.yes) { _, _ ->
                    viewModel.skipMicrotask()
                }
                builder.setNegativeButton(R.string.no) { _, _ ->
                    viewModel.setSkipTaskAlertTrigger(false)
                    viewModel.setActivityState(AudioRecorderActivityState.INIT)
                    viewModel.moveToPrerecording()
                }
                val dialog = builder.create()
                dialog.show()
            }
        }

    }

    private fun setupListener() {
        microtaskSpeechAudioInputAudioPlayButton_1.setOnClickListener {
            println("MADD one ${viewModel.inputAudioPlayerOneState.value}")
            when (viewModel.inputAudioPlayerOneState.value) {
                InputAudioPlayerState.PLAYING -> {
                    viewModel.controlInputAudioPlayer("Pause", "One")
                }

                InputAudioPlayerState.PREPARED,
                InputAudioPlayerState.PAUSED -> {
                    viewModel.controlInputAudioPlayer("Start", "One")
                }
            }
        }
        microtaskSpeechAudioInputAudioPlayButton_2.setOnClickListener {
            println("MADD two ${viewModel.inputAudioPlayerTwoState.value}")
            when (viewModel.inputAudioPlayerTwoState.value) {
                InputAudioPlayerState.PLAYING -> {
                    viewModel.controlInputAudioPlayer("Pause", "Two")
                }

                InputAudioPlayerState.PREPARED,
                InputAudioPlayerState.PAUSED -> {
                    viewModel.controlInputAudioPlayer("Start", "Two")
                }
            }
        }
    }

    private fun playRecordPrompt() {
//        val oldColor = speechImageSentenceTv.currentTextColor

        assistant.playAssistantAudio(
            AssistantAudio.RECORD_SENTENCE,
            uiCue = {
//                speechImageSentenceTv.setTextColor(Color.parseColor("#CC6666"))
                sentencePointerIv.visible()
            },
            onCompletionListener = {
                lifecycleScope.launch {
//                    speechImageSentenceTv.setTextColor(oldColor)
                    sentencePointerIv.invisible()
                    delay(500)
                    playRecordAction()
                }
            },
            onErrorListener = {
                lifecycleScope.launch {
                    if (!viewModel.extempore)
                        viewModel.moveToPrerecording()
                }
            }
        )
    }

    private fun playRecordAction() {

        lifecycleScope.launch {
            assistant.playAssistantAudio(
                AssistantAudio.RECORD_ACTION,
                uiCue = {
                    recordPointerIv.visible()
                    if (!viewModel.extempore)
                        speechImageRecordButton.setBackgroundResource(R.drawable.ic_mic_enabled)
                },
                onCompletionListener = {
                    lifecycleScope.launch {
                        recordPointerIv.invisible()
                        delay(500)
                        playStopAction()
                    }
                },
                onErrorListener = {
                    lifecycleScope.launch {
                        viewModel.moveToPrerecording()
                    }
                }
            )
            delay(1500)
            if (!viewModel.extempore)
                speechImageRecordButton.setBackgroundResource(R.drawable.ic_mic_active)
        }
    }

    private fun playStopAction() {

        lifecycleScope.launch {
            assistant.playAssistantAudio(
                AssistantAudio.STOP_ACTION,
                uiCue = { recordPointerIv.visible() },
                onCompletionListener = {
                    lifecycleScope.launch {
                        recordPointerIv.invisible()
                        delay(500)
                        playListenAction()
                    }
                },
                onErrorListener = {
                    lifecycleScope.launch {
                        viewModel.moveToPrerecording()
                    }
                }
            )
            delay(500)
            if (!viewModel.extempore)
                speechImageRecordButton.setBackgroundResource(R.drawable.ic_mic_disabled)
        }
    }

    private fun playListenAction() {

        assistant.playAssistantAudio(
            AssistantAudio.LISTEN_ACTION,
            uiCue = {
                playPointerIv.visible()
                speechImagePlayButton.setBackgroundResource(R.drawable.ic_speaker_active)
            },
            onCompletionListener = {
                lifecycleScope.launch {
                    speechImagePlayButton.setBackgroundResource(R.drawable.ic_speaker_disabled)
                    playPointerIv.invisible()
                    delay(500)
                    playRerecordAction()
                }
            },
            onErrorListener = {
                lifecycleScope.launch {
                    viewModel.moveToPrerecording()
                }
            }
        )
    }

    private fun playRerecordAction() {

        assistant.playAssistantAudio(
            AssistantAudio.RERECORD_ACTION,
            uiCue = {
                recordPointerIv.visible()
                if (!viewModel.extempore)
                    speechImageRecordButton.setBackgroundResource(R.drawable.ic_mic_enabled)
            },
            onCompletionListener = {
                lifecycleScope.launch {
                    if (!viewModel.extempore)
                        speechImageRecordButton.setBackgroundResource(R.drawable.ic_mic_disabled)
                    recordPointerIv.invisible()
                    delay(500)
                    playNextAction()
                }
            },
            onErrorListener = {
                lifecycleScope.launch {
                    viewModel.moveToPrerecording()
                }
            }
        )
    }

    private fun playNextAction() {

        assistant.playAssistantAudio(
            AssistantAudio.NEXT_ACTION,
            uiCue = {
                nextPointerIv.visible()
                speechImageNextButton.nextIv.setBackgroundResource(R.drawable.ic_next_enabled)
            },
            onCompletionListener = {
                lifecycleScope.launch {
                    speechImageNextButton.nextIv.setBackgroundResource(R.drawable.ic_next_disabled)
                    nextPointerIv.invisible()
                    delay(500)
                    playPreviousAction()
                }
            },
            onErrorListener = {
                lifecycleScope.launch {
                    viewModel.moveToPrerecording()
                }
            }
        )
    }

    private fun playPreviousAction() {

        assistant.playAssistantAudio(
            AssistantAudio.PREVIOUS_ACTION,
            uiCue = {
                backPointerIv.visible()
                speechImageBackButton.backIv.setBackgroundResource(R.drawable.ic_back_enabled)
            },
            onCompletionListener = {
                lifecycleScope.launch {
                    speechImageBackButton.backIv.setBackgroundResource(R.drawable.ic_back_disabled)
                    backPointerIv.invisible()
                    delay(500)
                    viewModel.moveToPrerecording()
                }
            },
            onErrorListener = {
                lifecycleScope.launch {
                    viewModel.moveToPrerecording()
                }
            }
        )
    }

    private fun setupUI() {
        microtaskSpeechAudioRecordButton.setOnClickListener { viewModel.handleRecordClick() }
        microtaskSpeechAudioPlayButton.setOnClickListener { viewModel.handlePlayClick() }
        speechImageNextButton.setOnClickListener { viewModel.handleNextClick() }
        speechImageBackButton.setOnClickListener { viewModel.handleBackClick() }

    }


    override fun onStop() {
        super.onStop()
        viewModel.cleanupOnStop()
    }

    override fun onResume() {
        super.onResume()
        viewModel.resetOnResume()
    }
}