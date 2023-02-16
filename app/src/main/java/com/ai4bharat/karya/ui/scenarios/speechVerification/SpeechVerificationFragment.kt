package com.ai4bharat.karya.ui.scenarios.speechVerification

import android.app.AlertDialog
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.karya.R
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.ui.scenarios.speechData.SpeechDataMainFragmentArgs
import com.ai4bharat.karya.ui.scenarios.speechVerification.SpeechVerificationViewModel.ButtonState
import com.ai4bharat.karya.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_common_back_button.view.*
import kotlinx.android.synthetic.main.microtask_common_next_button.view.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.*
import kotlinx.android.synthetic.main.microtask_speech_verification.*

@AndroidEntryPoint
class SpeechVerificationFragment : BaseMTRendererFragment(R.layout.microtask_speech_verification) {
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
//      if (this.task.name.contains("conversation",ignoreCase = true)){
//      accuracyGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            accuracyBadBtn.id -> handleAccuracyChange(R.string.accuracy_bad)
//            accuracyOkayBtn.id -> handleAccuracyChange(R.string.accuracy_okay)
//            accuracyGoodBtn.id -> handleAccuracyChange(R.string.accuracy_good)
//          }
//        }
//        bgChatterGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//          if (isChecked) {
//            when (checkedId) {
//              bgChatterBadBtn.id -> handleBgChatterChange(R.string.bgChatter_bad)
//              bgChatterOkayBtn.id -> handleBgChatterChange(R.string.bgChatter_okay)
//            }
//          }
//      }
//      }else{
//        accuracyGroup.invisible()
//        accuracyLbl.invisible()
//        handleAccuracyChange(-1)
//      }


//      if (this.task.name.contains("extempore",ignoreCase = true) || this.task.name.contains("conversation",ignoreCase = true) ){

//      qualityGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            qualityBadBtn.id -> handleQualityChange(R.string.quality_bad)
//            qualityOkayBtn.id -> handleQualityChange(R.string.quality_okay)
//            qualityGoodBtn.id -> handleQualityChange(R.string.quality_good)
//          }
//        }
//      }}
//      else{
//        qualityGroup.invisible()
//        qualityLbl.invisible()
//        handleQualityChange(-1)
//      }


      volumeGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            volumeBadBtn.id -> handleVolumeChange(R.string.volume_bad)
            volumeOkayBtn.id -> handleVolumeChange(R.string.volume_okay)
          }
        }
      }
      bgNoiseGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            bgNoiseBadBtn.id -> handleBgNoiseChange(R.string.bgNoise_bad)
            bgNoiseOkayBtn.id -> handleBgNoiseChange(R.string.bgNoise_okay)
          }
        }
      }
      cSwitchingGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            cSwitchingBadBtn.id -> handleCSwitchingChange(R.string.cSwitching_bad)
            cSwitchingOkayBtn.id -> handleCSwitchingChange(R.string.cSwitching_okay)
          }
        }
      }
      bgChatterGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            bgChatterBadBtn.id -> handleBgChatterChange(R.string.bgChatter_bad)
            bgChatterOkayBtn.id -> handleBgChatterChange(R.string.bgChatter_okay)
          }
        }
      }
      volapGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            volapBadBtn.id -> handleVoLapChange(R.string.volap_bad)
            volapOkayBtn.id -> handleVoLapChange(R.string.volap_okay)
          }
        }
      }
      sstGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            sstBadBtn.id -> handleSstChange(R.string.sst_bad)
            sstOkayBtn.id -> handleSstChange(R.string.sst_okay)
          }
        }
      }
      readQualityGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            readQualityBadBtn.id -> handleReadQChange(R.string.readQuality_bad)
            sstOkayBtn.id -> handleReadQChange(R.string.readQuality_okay)
          }
        }
      }
      extemporeQualityGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
        if (isChecked) {
          when (checkedId) {
            extemporeQualityBadBtn.id -> handleExtemporeQChange(R.string.extemporeQuality_bad)
            extemporeQualityOkayBtn.id -> handleExtemporeQChange(R.string.extemporeQuality_okay)
          }
        }
      }

//      fluencyGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            fluencyBadBtn.id -> handleFluencyChange(R.string.fluency_bad)
//            fluencyOkayBtn.id -> handleFluencyChange(R.string.fluency_okay)
//            fluencyGoodBtn.id -> handleFluencyChange(R.string.fluency_good)
//          }
//        }
//      }
    }
  }

  private fun setupObservers() {

    viewModel.sentenceTvText.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      sentenceTv.text = text
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

    viewModel.commentText.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      textComment.text = text
    }

//
//    viewModel.accuracyRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
////        R.string.accuracy_bad -> accuracyGroup.check(accuracyBadBtn.id)
////        R.string.accuracy_okay -> accuracyGroup.check(accuracyOkayBtn.id)
////        R.string.accuracy_good -> accuracyGroup.check(accuracyGoodBtn.id)
////        else -> accuracyGroup.clearChecked()
//      }
//    }
//
//    viewModel.qualityRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
////        R.string.quality_bad -> qualityGroup.check(qualityBadBtn.id)
////        R.string.quality_okay -> qualityGroup.check(qualityOkayBtn.id)
////        R.string.quality_good -> qualityGroup.check(qualityGoodBtn.id)
////        else -> qualityGroup.clearChecked()
//      }
//    }

    viewModel.volumeRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.volume_bad -> volumeGroup.check(volumeBadBtn.id)
        R.string.volume_okay -> volumeGroup.check(volumeOkayBtn.id)
        else -> volumeGroup.clearChecked()
      }
    }
    viewModel.bgNoiseRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.bgNoise_bad -> bgNoiseGroup.check(bgNoiseBadBtn.id)
        R.string.bgNoise_okay -> bgNoiseGroup.check(bgNoiseOkayBtn.id)
        else -> bgNoiseGroup.clearChecked()
      }
    }

    viewModel.cSwitchRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.cSwitching_bad -> cSwitchingGroup.check(cSwitchingBadBtn.id)
        R.string.cSwitching_okay -> cSwitchingGroup.check(cSwitchingOkayBtn.id)
        else -> cSwitchingGroup.clearChecked()
      }
    }
    viewModel.bgChatterRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.bgChatter_bad -> bgChatterGroup.check(bgChatterBadBtn.id)
        R.string.bgChatter_okay -> bgChatterGroup.check(bgChatterOkayBtn.id)
        else -> bgChatterGroup.clearChecked()
      }
    }

    viewModel.voLapRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.volap_bad -> volapGroup.check(volapBadBtn.id)
        R.string.volap_okay -> volapGroup.check(volapOkayBtn.id)
        else -> volapGroup.clearChecked()
      }
    }
    viewModel.sstRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.sst_bad -> sstGroup.check(sstBadBtn.id)
        R.string.sst_okay -> sstGroup.check(sstOkayBtn.id)
        else -> sstGroup.clearChecked()
      }
    }
    viewModel.handleReadQRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.readQuality_bad -> readQualityGroup.check(readQualityBadBtn.id)
        R.string.readQuality_okay -> readQualityGroup.check(readQualityOkayBtn.id)
        else -> readQualityGroup.clearChecked()
      }
    }
    viewModel.handleExtemporeQRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
      when (value) {
        R.string.extemporeQuality_bad -> extemporeQualityGroup.check(extemporeQualityBadBtn.id)
        R.string.extemporeQuality_okay -> extemporeQualityGroup.check(extemporeQualityOkayBtn.id)
        else -> extemporeQualityGroup.clearChecked()
      }
    }

//    viewModel.fluencyRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.fluency_bad -> fluencyGroup.check(fluencyBadBtn.id)
//        R.string.fluency_okay -> fluencyGroup.check(fluencyOkayBtn.id)
//        R.string.fluency_good -> fluencyGroup.check(fluencyGoodBtn.id)
//        else -> fluencyGroup.clearChecked()
//      }
//    }

    viewModel.reviewEnabled.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { enabled ->
      if (enabled) {
        enableReviewing()
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
//    accuracyGoodBtn.enable()
//    accuracyOkayBtn.enable()
//    accuracyBadBtn.enable()
//
//    qualityGoodBtn.enable()
//    qualityOkayBtn.enable()
//    qualityBadBtn.enable()

//    volumeGoodBtn.enable()
    volumeOkayBtn.enable()
    volumeBadBtn.enable()

    bgNoiseBadBtn.enable()
    bgNoiseOkayBtn.enable()

    cSwitchingBadBtn.enable()
    cSwitchingOkayBtn.enable()

    bgChatterBadBtn.enable()
    bgChatterOkayBtn.enable()

    volapBadBtn.enable()
    volapOkayBtn.enable()

    sstBadBtn.enable()
    sstOkayBtn.enable()


    readQualityBadBtn.enable()
    readQualityOkayBtn.enable()

    extemporeQualityBadBtn.enable()
    extemporeQualityOkayBtn.enable()

    commentCl.enable()

//    fluencyBadBtn.enable()
//    fluencyOkayBtn.enable()
//    fluencyGoodBtn.enable()
  }

  /** Disable reviewing */
  private fun disableReview() {
//    accuracyGoodBtn.disable()
//    accuracyOkayBtn.disable()
//    accuracyBadBtn.disable()
//
//    qualityGoodBtn.disable()
//    qualityOkayBtn.disable()
//    qualityBadBtn.disable()

//    volumeGoodBtn.disable()
    volumeOkayBtn.disable()
    volumeBadBtn.disable()

    bgNoiseBadBtn.disable()
    bgNoiseOkayBtn.disable()

    cSwitchingBadBtn.disable()
    cSwitchingOkayBtn.disable()

    bgChatterBadBtn.disable()
    bgChatterOkayBtn.disable()

    volapBadBtn.disable()
    volapOkayBtn.disable()

    sstBadBtn.disable()
    sstOkayBtn.disable()

    readQualityBadBtn.disable()
    readQualityOkayBtn.disable()

    extemporeQualityBadBtn.disable()
    extemporeQualityOkayBtn.disable()

    commentCl.disable()
//    fluencyBadBtn.disable()
//    fluencyOkayBtn.disable()
//    fluencyGoodBtn.disable()
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

}
