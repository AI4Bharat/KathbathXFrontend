package com.ai4bharat.karya.ui.scenarios.speechVerification

import android.app.AlertDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SeekBar
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.karya.R
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.ui.scenarios.speechData.SpeechDataMainFragmentArgs
import com.ai4bharat.karya.ui.scenarios.speechVerification.SpeechVerificationViewModel.ButtonState
import com.ai4bharat.karya.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.fragment_otp.view.*
import kotlinx.android.synthetic.main.item_task.*
import kotlinx.android.synthetic.main.microtask_common_back_button.view.*
import kotlinx.android.synthetic.main.microtask_common_next_button.view.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.*
import kotlinx.android.synthetic.main.microtask_speech_verification.*
import kotlinx.android.synthetic.main.microtask_speech_verification.view.*

@AndroidEntryPoint
class SpeechVerificationFragment : BaseMTRendererFragment(R.layout.microtask_speech_verification),SeekBar.OnSeekBarChangeListener {
  override val viewModel: SpeechVerificationViewModel by viewModels()
  val args: SpeechDataMainFragmentArgs by navArgs()

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
    /** Set on click listeners for buttons */
    playBtn.setOnClickListener { viewModel.handlePlayClick() }
    nextBtnCv.setOnClickListener { viewModel.handleNextClick() }
    with (viewModel) {
      decisionGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            decisionBadBtn.id -> handleDecisionChange(R.string.decision_bad)
            decisionExcellentBtn.id -> handleDecisionChange(R.string.decision_excellent)
//            decisionOkayBtn.id -> handleDecisionChange(R.string.decision_okay)
          }
          textComment.disable()
        }
      }
      volumeTick.setOnCheckedChangeListener { _, b -> handleVolumeTickChange(b) }
      noiseTick.setOnCheckedChangeListener { _, b -> handleNoiseTickChange(b) }
      chatterTickIntermittent.setOnCheckedChangeListener { _, b -> handleChatterTickIntermittentChange(b) }
      fanTick.setOnCheckedChangeListener { _, b -> handleFanTickChange(b) }
      silenceTick.setOnCheckedChangeListener { _, b -> handleSilenceTickChange(b) }
      pageFlipTick.setOnCheckedChangeListener{ _, b -> handlePageFlipTickChange(b)}
      objContTick.setOnCheckedChangeListener{ _, b -> handleObjContTickChange(b)}
      skippingWordsTick.setOnCheckedChangeListener{ _, b -> handleSkippingWordsTickChange(b)}
      incorrectTextTick.setOnCheckedChangeListener{ _, b -> handleIncorrectTextTickChange(b)}
      incorrectStyleTick.setOnCheckedChangeListener{ _, b -> handleIncorrectStyleTickChange(b)}
      unnaturalTick.setOnCheckedChangeListener{ _, b -> handleUnnaturalTickChange(b)}
      repContentTick.setOnCheckedChangeListener{ _, b -> handleRepContentTickChange(b)}
      tooSlowTick.setOnCheckedChangeListener{ _, b -> handleTooSlowTickChange(b)}
      tooFastTick.setOnCheckedChangeListener{ _, b -> handleTooFastTickChange(b)}
      misPronTick.setOnCheckedChangeListener{ _, b -> handleMisPronTickChange(b)}
      wrongSpeakerTick.setOnCheckedChangeListener{ _, b -> handleWrongSpeakerTickChange(b)}
      weakEmotionTick.setOnCheckedChangeListener{ _, b -> handleWeakEmotionTickChange(b)}
      othersTick.setOnCheckedChangeListener { _, b -> handleOthersTickChange(b) }
      dramaticTick.setOnCheckedChangeListener { _, b -> handleDramaticTickChange(b) }
      otherTick.setOnCheckedChangeListener { _, b -> handleCommentsTickChange(b) }
      wrongLang.setOnCheckedChangeListener { _, b -> handleWrongLangTickChange(b) }
      echoTick.setOnCheckedChangeListener { _, b -> handleEchoTickChange(b) }
      textComment.addTextChangedListener(textComment.doAfterTextChanged {
      text -> handleCommentTextChange(text.toString()) })
      progressPb.setOnSeekBarChangeListener(this@SpeechVerificationFragment)
   }
  }

  private fun setupObservers() {

    viewModel.sentenceTvText.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      sentenceTv.text = text
    }

    viewModel.microtaskID.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { id ->
      wrongLang.isChecked = false
      echoTick.isChecked = false
      objContTick.isChecked = false
      skippingWordsTick.isChecked = false
      incorrectTextTick.isChecked = false
      incorrectStyleTick.isChecked = false
      volumeTick.isChecked = false
      noiseTick.isChecked = false
      chatterTickIntermittent.isChecked = false
      fanTick.isChecked = false
      silenceTick.isChecked = false
      pageFlipTick.isChecked = false
      unnaturalTick.isChecked = false
      repContentTick.isChecked = false
      tooSlowTick.isChecked = false
      misPronTick.isChecked = false
      wrongSpeakerTick.isChecked = false
      weakEmotionTick.isChecked = false
      othersTick.isChecked = false
      tooFastTick.isChecked = false
      dramaticTick.isChecked = false
      otherTick.isChecked = false
      progressPb.isEnabled = false
      commonCl1.gone()
      commonCl2.gone()
      commonCl3.gone()
      commonCl4.gone()
      conversationsCl.gone()
      commentCl.gone()
    }

    viewModel.playbackSecondsTvText.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      playbackProgress.secondsTv.text = text
    }

    viewModel.playbackCentiSecondsTvText.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      playbackProgress.centiSecondsTv.text = text
    }

    viewModel.playbackProgressPbMax.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { max ->
      playbackProgress.progressPb.max = max
    }

    viewModel.playbackProgress.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { progress ->
      playbackProgress.progressPb.progress = progress
    }

    viewModel.navAndMediaBtnGroup.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { states ->
      flushButtonStates(states.first, states.second, states.third)
    }

    viewModel.decisionRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.decision_okay -> {
//          decisionGroup.check(decisionOkayBtn.id)
          commonCl1.visible()
          commonCl2.visible()
          commonCl3.visible()
          commonCl4.visible()
          commentCl.visible()

          if (viewModel.task.name.contains("[read]",ignoreCase = true)){
//            commonCl4.gone()
            conversationsCl.gone()
          }
          else if ( viewModel.task.name.contains("extempore",ignoreCase = true)){
            commonCl4.visible()
            conversationsCl.gone()
          }
          else if (viewModel.task.name.contains("[conversation",ignoreCase = true)){
//            commonCl4.gone()
            conversationsCl.visible()
          }
        }
        R.string.decision_bad -> {
          decisionGroup.check(decisionBadBtn.id)
          commonCl1.visible()
          commonCl2.visible()
          commonCl3.visible()
          commonCl4.visible()
          commentCl.visible()

          if (viewModel.task.name.contains("[read]",ignoreCase = true)){
//            commonCl4.gone()
            conversationsCl.gone()
          }
          else if ( viewModel.task.name.contains("extempore",ignoreCase = true)){
            commonCl4.visible()
            conversationsCl.gone()
          }
          else if (viewModel.task.name.contains("[conversation",ignoreCase = true)){
//            commonCl4.gone()
            conversationsCl.visible()
          }
        }
        R.string.decision_excellent -> {
          decisionGroup.check(decisionExcellentBtn.id)
          commonCl1.gone()
          commonCl2.gone()
          commonCl3.gone()
          commentCl.gone()
          commonCl4.gone()
          conversationsCl.gone()
        }
        else -> decisionGroup.clearChecked()
      }
    }

    viewModel.commentTickHandler.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      if (value) {
        textComment.enable()
      }
      else{
        textComment.text?.clear()
        textComment.disable()
      }
    }

    viewModel.reviewEnabled.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { enabled ->
      if (enabled) {
        enableReviewing()
        progressPb.isEnabled = true
      } else {
        disableReview()
      }
    }

    viewModel.showErrorWithDialog.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { msg ->
      if (msg.isNotEmpty()) {
        showErrorDialog(msg)
      }
    }
  }

  private fun showErrorDialog(msg: String) {
    val alertDialogBuilder = AlertDialog.Builder(requireContext())
    alertDialogBuilder.setMessage(msg)
    alertDialogBuilder.setNeutralButton("Ok") { _, _ ->
      viewModel.handleCorruptAudio()
    }
    val alertDialog = alertDialogBuilder.create()
    alertDialog.setCancelable(false)
    alertDialog.setCanceledOnTouchOutside(false)
    alertDialog.show()
  }

  /** Enable reviewing */
  private fun enableReviewing() {
    decisionBadBtn.enable()
    decisionExcellentBtn.enable()
//    decisionOkayBtn.enable()
    volumeTick.enable()
    objContTick.enable()
    skippingWordsTick.enable()
    incorrectTextTick.enable()
    incorrectStyleTick.enable()
    wrongLang.enable()
    echoTick.enable()
    noiseTick.enable()
    chatterTickIntermittent.enable()
    fanTick.enable()
    silenceTick.enable()
    pageFlipTick.enable()
    unnaturalTick.enable()
    repContentTick.enable()
    tooSlowTick.enable()
    misPronTick.enable()
    wrongSpeakerTick.enable()
    weakEmotionTick.enable()
    othersTick.enable()
    tooFastTick.enable()
    dramaticTick.enable()
    textComment.enable()
    otherTick.enable()
  }

  /** Disable reviewing */
  private fun disableReview() {
    decisionBadBtn.disable()
    decisionExcellentBtn.disable()
//    decisionOkayBtn.disable()
    objContTick.disable()
    skippingWordsTick.disable()
    incorrectTextTick.disable()
    incorrectStyleTick.disable()
    volumeTick.disable()
    noiseTick.disable()
    chatterTickIntermittent.disable()
    fanTick.disable()
    silenceTick.disable()
    pageFlipTick.disable()
    pageFlipTick.disable()
    unnaturalTick.disable()
    repContentTick.disable()
    tooSlowTick.disable()
    misPronTick.disable()
    wrongSpeakerTick.disable()
    weakEmotionTick.disable()
    othersTick.disable()
    tooFastTick.disable()
    dramaticTick.disable()
    textComment.disable()
    otherTick.disable()
    wrongLang.disable()
    echoTick.disable()
  }

  /** Flush the button states */
  private fun flushButtonStates(
    backBtnState: ButtonState,
    playBtnState: ButtonState,
    nextBtnState: ButtonState
  ) {
    playBtn.isClickable = playBtnState != ButtonState.DISABLED
    backBtn.isClickable = backBtnState != ButtonState.DISABLED
    nextBtnCv.isClickable = nextBtnState != ButtonState.DISABLED

    playBtn.setBackgroundResource(
      when (playBtnState) {
        ButtonState.DISABLED -> R.drawable.ic_speaker_disabled
        ButtonState.ENABLED -> R.drawable.ic_speaker_enabled
        ButtonState.ACTIVE -> R.drawable.ic_speaker_active
      }
    )

    nextBtnCv.nextIv.setBackgroundResource(
      when (nextBtnState) {
        ButtonState.DISABLED -> R.drawable.ic_next_disabled
        ButtonState.ENABLED -> R.drawable.ic_next_enabled
        ButtonState.ACTIVE -> R.drawable.ic_next_enabled
      }
    )

    backBtn.backIv.setBackgroundResource(
      when (backBtnState) {
        ButtonState.DISABLED -> R.drawable.ic_back_disabled
        ButtonState.ENABLED -> R.drawable.ic_back_enabled
        ButtonState.ACTIVE -> R.drawable.ic_back_enabled
      }
    )
  }

  override fun onProgressChanged(p0: SeekBar?, p1: Int, p2: Boolean) {
      viewModel.handleSeekBarChange(p1, p2)
  }

  override fun onStartTrackingTouch(p0: SeekBar?) {

//    Log.e("OnStartTracking","Start Tracking"+p0.toString())

  }

  override fun onStopTrackingTouch(p0: SeekBar?) {
//    Log.e("OnStopTracking","Start Tracking"+p0.toString())
  }

}
