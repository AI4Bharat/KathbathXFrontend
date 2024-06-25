package com.ai4bharat.kathbath.ui.scenarios.speechImageData

import android.app.AlertDialog
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.activity.addCallback
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.AssistantAudio
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.kathbath.ui.scenarios.speechData.getInstructionSentence
import com.ai4bharat.kathbath.utils.LanguageUtils
import com.ai4bharat.kathbath.utils.extensions.observe
import com.ai4bharat.kathbath.utils.extensions.viewLifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import com.ai4bharat.kathbath.ui.scenarios.speechImageData.SpeechImageDataViewModel.ButtonState.*
import com.ai4bharat.kathbath.utils.extensions.invisible
import com.ai4bharat.kathbath.utils.extensions.visible
import com.google.firebase.crashlytics.internal.model.CrashlyticsReport.FilesPayload.File
import kotlinx.android.synthetic.main.microtask_speech_image_data.backPointerIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.inputAudioPlayButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.inputAudioProgressBar
import kotlinx.android.synthetic.main.microtask_speech_image_data.instructionTv
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
import kotlinx.android.synthetic.main.microtask_common_back_button.view.backIv
import kotlinx.android.synthetic.main.microtask_common_next_button.view.nextIv
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageCurrentTime
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageImageView
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageTotalTime
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


@AndroidEntryPoint
class SpeechImageDataFragment : BaseMTRendererFragment(R.layout.microtask_speech_image_data) {

    override val viewModel: SpeechImageDataViewModel by viewModels()
    val args: SpeechImageDataFragmentArgs by navArgs()

    private val TAG = "Speech Image"

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

        setupObservers()
        viewModel.setupSpeechDataViewModel()
        setupUI()
        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) { viewModel.onBackPressed() }
    }


    private fun setupObservers() {

        viewModel.inputImageSource.observe(viewLifecycleOwner) {
            val imgFile = java.io.File(it)
            if (imgFile.exists()) {
                val bitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
                speechImageImageView.setImageBitmap(bitmap)
            } else {
                TODO("Put a dummy image")
            }
        }

        viewModel.workerDetails.observe(viewLifecycleOwner, Observer { workerRecord ->
            val recordInstruction =
                viewModel.task.params.asJsonObject.get("instruction").asString
            if (recordInstruction != "-") {
                instructionTv.text = "Instruction: $recordInstruction"
            } else {
                val languageCode = workerRecord.language
                val language = LanguageUtils.getLanguageFromCode(languageCode)
                if (language == "")
                    instructionTv.text = "Instruction: $recordInstruction"
                instructionTv.text = getInstructionSentence(language)
            }

        })

        viewModel.inputAudioProgress.observe(viewLifecycleOwner) {
            inputAudioProgressBar.progress = it
        }

        viewModel.inputAudioPlayerTimestamp.observe(viewLifecycleOwner) {
            speechImageCurrentTime.text = it.first
            speechImageTotalTime.text = it.second
        }

        viewModel.backBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            speechImageBackButton.isClickable = state != DISABLED
            speechImageBackButton.backIv.setBackgroundResource(
                when (state) {
                    DISABLED -> R.drawable.ic_back_disabled
                    ENABLED -> R.drawable.ic_back_enabled
                    ACTIVE -> R.drawable.ic_back_enabled
                }
            )
        }

        viewModel.recordBtnState.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { state ->
            speechImageRecordButton.isClickable =
                state != DISABLED
            if (viewModel.extempore) {
                speechImageRecordButton.setBackgroundResource(R.drawable.button_upload_foreground)
                return@observe
            }
            speechImageRecordButton.setBackgroundResource(
                when (state) {
                    DISABLED -> R.drawable.ic_mic_disabled
                    ENABLED -> R.drawable.ic_mic_enabled
                    ACTIVE -> R.drawable.ic_mic_active
                }
            )
        }

        viewModel.inputAudioPlayerState.observe(viewLifecycleOwner) { state ->
            when (state) {
                InputAudioPlayerState.PLAYING -> {
                    inputAudioPlayButton.setBackgroundResource(R.drawable.baseline_pause_circle_outline_24)
                }

                else -> {
                    inputAudioPlayButton.setBackgroundResource(R.drawable.baseline_play_circle_outline_24)
                }
            }
        }

        viewModel.playBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            speechImagePlayButton.isClickable =
                state != DISABLED
            speechImagePlayButton.setBackgroundResource(
                when (state) {
                    DISABLED -> R.drawable.ic_speaker_disabled
                    ENABLED -> R.drawable.ic_speaker_enabled
                    ACTIVE -> R.drawable.ic_speaker_active
                }
            )
        }

        viewModel.nextBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
            speechImageNextButton.isClickable = state != DISABLED
            speechImageNextButton.nextIv.setBackgroundResource(
                when (state) {
                    DISABLED -> R.drawable.ic_next_disabled
                    ENABLED -> R.drawable.ic_next_enabled
                    ACTIVE -> R.drawable.ic_next_enabled
                }
            )
        }

        // Set microtask instruction if available
        viewModel.microTaskInstruction.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { text ->
            if (!text.isNullOrEmpty()) {
                instructionTv.text = text
            }
        }

//        viewModel.sentenceTvText.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { text ->
//            speechImageSentenceTv.text = text
//            speechImageSentenceTv.movementMethod = ScrollingMovementMethod()
//        }

        viewModel.recordSecondsTvText.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { text ->
            recordSecondsTv.text = text
        }

        viewModel.recordCentiSecondsTvText.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { text ->
            recordCentiSecondsTv.text = text
        }

        viewModel.playbackProgressPb.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { progress ->
            playbackProgressPb.progress = progress
        }

        viewModel.playbackProgressPbMax.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { max ->
            playbackProgressPb.max = max
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
                    viewModel.setActivityState(SpeechImageDataViewModel.ActivityState.INIT)
                    viewModel.moveToPrerecording()
                }
                val dialog = builder.create()
                dialog.show()
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
        speechImageRecordButton.setOnClickListener { viewModel.handleRecordClick() }
        speechImagePlayButton.setOnClickListener { viewModel.handlePlayClick() }

        speechImageNextButton.setOnClickListener { viewModel.handleNextClick() }
        speechImageBackButton.setOnClickListener { viewModel.handleBackClick() }

        inputAudioPlayButton.setOnClickListener {
            when (viewModel.inputAudioPlayerState.value) {
                InputAudioPlayerState.PLAYING ->
                    viewModel.controlInputAudio("Pause")

                else -> viewModel.controlInputAudio("Start")
            }
        }

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
















