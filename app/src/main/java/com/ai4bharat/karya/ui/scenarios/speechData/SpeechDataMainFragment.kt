package com.ai4bharat.karya.ui.scenarios.speechData

import android.app.Activity
import android.app.AlertDialog
import android.content.ContentResolver
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.MimeTypeMap
import androidx.activity.addCallback
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.model.karya.enums.AssistantAudio
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.ui.scenarios.speechData.SpeechDataMainViewModel.ButtonState.*
import com.ai4bharat.karya.utils.extensions.invisible
import com.ai4bharat.karya.utils.extensions.observe
import com.ai4bharat.karya.utils.extensions.viewLifecycleScope
import com.ai4bharat.karya.utils.extensions.visible
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_common_back_button.view.*
import kotlinx.android.synthetic.main.microtask_common_next_button.view.*
import kotlinx.android.synthetic.main.microtask_speech_data.*
import kotlinx.android.synthetic.main.microtask_speech_data.view.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File
import kotlin.io.path.Path

@AndroidEntryPoint
class SpeechDataMainFragment : BaseMTRendererFragment(R.layout.microtask_speech_data) {
  override val viewModel: SpeechDataMainViewModel by viewModels()
  val args: SpeechDataMainFragmentArgs by navArgs()

  private fun getFileFromUri(contentResolver: ContentResolver, uri: Uri, filepath: String): File {
    var file = File(filepath)
    file.createNewFile()
    file.outputStream().use {
      contentResolver.openInputStream(uri)?.copyTo(it)
    }
    return file
  }
  private var resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
    if (result.resultCode == Activity.RESULT_OK) {
      // There are no request codes

      val file = result.data?.data?.let {

//        Log.e("[PATH]", requireContext().contentResolver.getType(it).toString())
        val ext = MimeTypeMap.getSingleton().getExtensionFromMimeType(requireContext().contentResolver.getType(it)).toString()
        getFileFromUri(requireContext().contentResolver, it, viewModel.getScratchPath(Pair("",ext)))
//        Log.e("[State]",viewModel.activityState.toString())

        viewModel.setPaths(Pair("",ext))
//        Log.e("[State]",viewModel.activityState.toString())
      }

    }
  }

  override fun requiredPermissions(): Array<String> {
    return arrayOf(android.Manifest.permission.RECORD_AUDIO)
  }

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {
    val view = super.onCreateView(inflater, container, savedInstanceState)
    // TODO: Remove this once we have viewModel Factory
    viewModel.setupViewModel(args.taskId, args.completed, args.total)

    return view
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    setupObservers()

    // Setup speech data view model
    viewModel.setupSpeechDataViewModel()
    /** Set OnBackPressed callback */
    requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) { viewModel.onBackPressed() }

    /** record instruction */
    val recordInstruction =
      viewModel.task.params.asJsonObject.get("instruction").asString
        ?: getString(R.string.speech_recording_instruction)
    instructionTv.text = recordInstruction
    Log.e("HERE",viewModel.task.toString())
    /** Set on click listeners */

    if (viewModel.task.name.contains("Extempore Dialogue",true)){
      recordBtn.setBackgroundResource(R.drawable.ic_speaker_disabled)
      recordBtn.setOnClickListener {
        viewModel.moveToPrerecording()
        playRecordPrompt()
        val intent = Intent()
        intent.type = "audio/*"
        intent.action = Intent.ACTION_GET_CONTENT
        /** Sets the path in path variable **/
        resultLauncher.launch(Intent.createChooser(intent,"Select Audio "))
      }
      playBtn.setOnClickListener { viewModel.handlePlayClick() }
      nextBtnCv.setOnClickListener { viewModel.handleNextClick() }
      backBtn.setOnClickListener { viewModel.handleBackClick() }
    }
  else{
    recordBtn.setOnClickListener {
      viewModel.handleRecordClick() }
    playBtn.setOnClickListener { viewModel.handlePlayClick() }
    nextBtnCv.setOnClickListener { viewModel.handleNextClick() }
    backBtn.setOnClickListener { viewModel.handleBackClick() }
    }
  }

  private fun setupObservers() {
    viewModel.backBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
      backBtn.isClickable = state != DISABLED
      backBtn.backIv.setBackgroundResource(
        when (state) {
          DISABLED -> R.drawable.ic_back_disabled
          ENABLED -> R.drawable.ic_back_enabled
          ACTIVE -> R.drawable.ic_back_enabled
        }
      )
    }

    viewModel.recordBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
      recordBtn.isClickable = state != DISABLED
      if (viewModel.extempore){
        recordBtn.setBackgroundResource(R.drawable.button_upload_foreground)
        return@observe
      }
      recordBtn.setBackgroundResource(
        when (state) {
          DISABLED -> R.drawable.ic_mic_disabled
          ENABLED -> R.drawable.ic_mic_enabled
          ACTIVE -> R.drawable.ic_mic_active
        }
      )
    }

    viewModel.playBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
      playBtn.isClickable = state != DISABLED
      playBtn.setBackgroundResource(
        when (state) {
          DISABLED -> R.drawable.ic_speaker_disabled
          ENABLED -> R.drawable.ic_speaker_enabled
          ACTIVE -> R.drawable.ic_speaker_active
        }
      )
    }

    viewModel.nextBtnState.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { state ->
      nextBtnCv.isClickable = state != DISABLED
      nextBtnCv.nextIv.setBackgroundResource(
        when (state) {
          DISABLED -> R.drawable.ic_next_disabled
          ENABLED -> R.drawable.ic_next_enabled
          ACTIVE -> R.drawable.ic_next_enabled
        }
      )
    }

    // Set microtask instruction if available
    viewModel.microTaskInstruction.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { text ->
      if (!text.isNullOrEmpty()) {
        instructionTv.text = text
      }
    }

    viewModel.sentenceTvText.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { text ->
      sentenceTv.text = text
    }

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
        val message = getString(R.string.skip_task_warning)
        builder.setMessage(message)
        builder.setPositiveButton(R.string.yes) { _, _ ->
          viewModel.skipMicrotask()
        }
        builder.setNegativeButton(R.string.no) { _, _ ->
          viewModel.setSkipTaskAlertTrigger(false)
          viewModel.moveToPrerecording()
        }
        val dialog = builder.create()
        dialog.show()
      }
    }
  }

  private fun playRecordPrompt() {
    val oldColor = sentenceTv.currentTextColor

    assistant.playAssistantAudio(
      AssistantAudio.RECORD_SENTENCE,
      uiCue = {
        sentenceTv.setTextColor(Color.parseColor("#CC6666"))
        sentencePointerIv.visible()
      },
      onCompletionListener = {
        lifecycleScope.launch {
          sentenceTv.setTextColor(oldColor)
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
          recordBtn.setBackgroundResource(R.drawable.ic_mic_enabled)
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
      recordBtn.setBackgroundResource(R.drawable.ic_mic_active)
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
      recordBtn.setBackgroundResource(R.drawable.ic_mic_disabled)
    }
  }

  private fun playListenAction() {

    assistant.playAssistantAudio(
      AssistantAudio.LISTEN_ACTION,
      uiCue = {
        playPointerIv.visible()
        playBtn.setBackgroundResource(R.drawable.ic_speaker_active)
      },
      onCompletionListener = {
        lifecycleScope.launch {
          playBtn.setBackgroundResource(R.drawable.ic_speaker_disabled)
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
        recordBtn.setBackgroundResource(R.drawable.ic_mic_enabled)
      },
      onCompletionListener = {
        lifecycleScope.launch {
          if (!viewModel.extempore)
          recordBtn.setBackgroundResource(R.drawable.ic_mic_disabled)
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
        nextBtnCv.nextIv.setBackgroundResource(R.drawable.ic_next_enabled)
      },
      onCompletionListener = {
        lifecycleScope.launch {
          nextBtnCv.nextIv.setBackgroundResource(R.drawable.ic_next_disabled)
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
        backBtn.backIv.setBackgroundResource(R.drawable.ic_back_enabled)
      },
      onCompletionListener = {
        lifecycleScope.launch {
          backBtn.backIv.setBackgroundResource(R.drawable.ic_back_disabled)
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

  override fun onStop() {
    super.onStop()
    viewModel.cleanupOnStop()
  }

  override fun onResume() {
    super.onResume()
    viewModel.resetOnResume()
  }
}
