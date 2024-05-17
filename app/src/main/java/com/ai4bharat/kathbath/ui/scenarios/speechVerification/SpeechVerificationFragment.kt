package com.ai4bharat.kathbath.ui.scenarios.speechVerification

import android.app.AlertDialog
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SeekBar
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.kathbath.ui.scenarios.speechData.SpeechDataMainFragmentArgs
import com.ai4bharat.kathbath.ui.scenarios.speechVerification.SpeechVerificationViewModel.ButtonState
import com.ai4bharat.kathbath.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.fragment_otp.view.*
import kotlinx.android.synthetic.main.item_task.*
import kotlinx.android.synthetic.main.microtask_common_back_button.view.*
import kotlinx.android.synthetic.main.microtask_common_next_button.view.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.*
import kotlinx.android.synthetic.main.microtask_speech_verification.*
import kotlinx.android.synthetic.main.microtask_speech_verification.commonCl1
import kotlinx.android.synthetic.main.microtask_speech_verification.nextBtnCv
import kotlinx.android.synthetic.main.microtask_speech_verification.sentenceTv
import kotlinx.android.synthetic.main.microtask_speech_verification.view.*
import kotlinx.android.synthetic.main.microtask_speech_verification.wrongAgeGroup
import kotlinx.android.synthetic.main.microtask_speech_verification.wrongGender

@AndroidEntryPoint
class SpeechVerificationFragment : BaseMTRendererFragment(R.layout.microtask_speech_verification),
    SeekBar.OnSeekBarChangeListener {
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
        with(viewModel) {
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
            decisionGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
                if (isChecked) {
                    when (checkedId) {
                        decisionBadBtn.id -> handleDecisionChange(R.string.decision_bad)
                        decisionExcellentBtn.id -> handleDecisionChange(R.string.decision_excellent)
                        decisionOkayBtn.id -> handleDecisionChange(R.string.decision_okay)
                    }
                    textComment.disable()
                }
            }
            volumeTick.setOnCheckedChangeListener { _, b -> handleVolumeTickChange(b) }
//      noiseTick.setOnCheckedChangeListener { _, b -> handleNoiseTickChange(b) }
//      chatterTick.setOnCheckedChangeListener { _, b -> handleChatterTickChange(b) }
            noiseTickIntermittent.setOnCheckedChangeListener { _, b ->
                handleNoiseTickIntermittentChange(
                    b
                )
            }
            chatterTickIntermittent.setOnCheckedChangeListener { _, b ->
                handleChatterTickIntermittentChange(
                    b
                )
            }
            noiseTickPersistent.setOnCheckedChangeListener { _, b ->
                handleNoiseTickPersistentChange(
                    b
                )
            }
            chatterTickPersistent.setOnCheckedChangeListener { _, b ->
                handleChatterTickPersistentChange(
                    b
                )
            }
            unclearAudioTick.setOnCheckedChangeListener { _, b -> handleUnclearAudioTickChange(b) }
//      miscTick.setOnCheckedChangeListener{ _, b -> handleMiscTickChange(b)}

            objContTick.setOnCheckedChangeListener { _, b -> handleObjContTickChange(b) }
            skippingWordsTick.setOnCheckedChangeListener { _, b -> handleSkippingWordsTickChange(b) }
            incorrectTextTick.setOnCheckedChangeListener { _, b -> handleIncorrectTextTickChange(b) }
            factualInaccuracyTick.setOnCheckedChangeListener { _, b -> handleFactualInaccuracyTick(b) }

            notOnTopicTick.setOnCheckedChangeListener { _, b -> handleNotOnTopicTickChange(b) }
            repContentTick.setOnCheckedChangeListener { _, b -> handleRepContentTickChange(b) }
            longPausesTick.setOnCheckedChangeListener { _, b -> handleLongPausesTickChange(b) }
            stretchingTick.setOnCheckedChangeListener { _, b -> handleStretchingTickChange(b) }

            misPronTick.setOnCheckedChangeListener { _, b -> handleMisPronTickChange(b) }


            readPromptTick.setOnCheckedChangeListener { _, b -> handleReadPromptTickChange(b) }
            bookReadTick.setOnCheckedChangeListener { _, b -> handleBookReadTickChange(b) }

            sstTick.setOnCheckedChangeListener { _, b -> handleSSTTickChange(b) }
//      readQTick.setOnCheckedChangeListener { _, b -> handleReadQTickChange(b) }
            badExtemporeTick.setOnCheckedChangeListener { _, b -> handleBadExtemporeTickChange(b) }
            otherTick.setOnCheckedChangeListener { _, b -> handleCommentsTickChange(b) }
            wrongLang.setOnCheckedChangeListener { _, b -> handleWrongLangTickChange(b) }
            echoTick.setOnCheckedChangeListener { _, b -> handleEchoTickChange(b) }
            wrongGender.setOnCheckedChangeListener { _, b -> handleWrongGenderTickChange(b) }
            wrongAgeGroup.setOnCheckedChangeListener { _, b -> handleWrongAgeGroupTickChange(b) }
            audioDuplicateSpeaker.setOnCheckedChangeListener { _, b ->
                handleDuplicateSpeakerTickChange(
                    b
                )
            }


            textComment.addTextChangedListener(textComment.doAfterTextChanged { text ->
                handleCommentTextChange(
                    text.toString()
                )
            })

            progressPb.setOnSeekBarChangeListener(this@SpeechVerificationFragment)
//      progressPb.setOnClickListener(progressPb.rootView)
            //      textComment.addTextChangedListener()

//      volumeGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            volumeBadBtn.id -> handleVolumeChange(R.string.volume_bad)
//            volumeOkayBtn.id -> handleVolumeChange(R.string.volume_okay)
//          }
//        }
//      }
//      bgNoiseGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            bgNoiseBadBtn.id -> handleBgNoiseChange(R.string.bgNoise_bad)
//            bgNoiseOkayBtn.id -> handleBgNoiseChange(R.string.bgNoise_okay)
//          }
//        }
//      }
//      cSwitchingGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            cSwitchingBadBtn.id -> handleCSwitchingChange(R.string.cSwitching_bad)
//            cSwitchingOkayBtn.id -> handleCSwitchingChange(R.string.cSwitching_okay)
//          }
//        }
//      }
//      bgChatterGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            bgChatterBadBtn.id -> handleBgChatterChange(R.string.bgChatter_bad)
//            bgChatterOkayBtn.id -> handleBgChatterChange(R.string.bgChatter_okay)
//          }
//        }
//      }
//      volapGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            volapBadBtn.id -> handleVoLapChange(R.string.volap_bad)
//            volapOkayBtn.id -> handleVoLapChange(R.string.volap_okay)
//          }
//        }
//      }
//      sstGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            sstBadBtn.id -> handleSstChange(R.string.sst_bad)
//            sstOkayBtn.id -> handleSstChange(R.string.sst_okay)
//          }
//        }
//      }
//      readQualityGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            readQualityBadBtn.id -> handleReadQChange(R.string.readQuality_bad)
//            sstOkayBtn.id -> handleReadQChange(R.string.readQuality_okay)
//          }
//        }
//      }
//      extemporeQualityGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
//        if (isChecked) {
//          when (checkedId) {
//            extemporeQualityBadBtn.id -> handleExtemporeQChange(R.string.extemporeQuality_bad)
//            extemporeQualityOkayBtn.id -> handleExtemporeQChange(R.string.extemporeQuality_okay)
//          }
//        }
//      }

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
            sentenceTv.movementMethod = ScrollingMovementMethod()
        }

        viewModel.fileID.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            fileId.text = text
        }

        viewModel.phoneNumber.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            phoneNumber.text = text
        }

        viewModel.fileGender.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            fileGender.text = text
        }

        viewModel.fileAgeGroup.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            fileAgeGroup.text = text
        }

        viewModel.microtaskID.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { id ->
//      miscTick.isChecked = false

            audioDuplicateSpeaker.isChecked = false
            wrongLang.isChecked = false
            echoTick.isChecked = false
            objContTick.isChecked = false
            wrongGender.isChecked = false
            wrongAgeGroup.isChecked = false
            skippingWordsTick.isChecked = false
            incorrectTextTick.isChecked = false
            factualInaccuracyTick.isChecked = false
            volumeTick.isChecked = false
//      noiseTick.isChecked = false
//      chatterTick.isChecked = false
            noiseTickIntermittent.isChecked = false
            chatterTickIntermittent.isChecked = false
            noiseTickPersistent.isChecked = false
            chatterTickPersistent.isChecked = false
            unclearAudioTick.isChecked = false

            notOnTopicTick.isChecked = false
            repContentTick.isChecked = false
            longPausesTick.isChecked = false

            misPronTick.isChecked = false

            readPromptTick.isChecked = false
            bookReadTick.isChecked = false


            sstTick.isChecked = false

            stretchingTick.isChecked = false
//      readQTick.isChecked = false
            badExtemporeTick.isChecked = false
            otherTick.isChecked = false

            progressPb.isEnabled = false

//      comm.gone()
//      co.gone()
            commonCl1.gone()
            commonCl2.gone()
            commonCl3.gone()
            commonCl4.gone()

//      readCl.gone()
            extemporeCl.gone()
            conversationsCl.gone()
            commentCl.gone()
//      sreCl.gone()

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


        viewModel.decisionRating.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { value ->


            when (value) {
                R.string.decision_okay -> {
                    decisionGroup.check(decisionOkayBtn.id)
                    commonCl1.visible()
                    commonCl2.visible()
                    commonCl3.visible()
                    commonCl4.visible()
                    commentCl.visible()

                    if (viewModel.task.name.contains("[read]", ignoreCase = true)) {
//            readCl.visible()
                        extemporeCl.gone()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("extempore", ignoreCase = true)) {
//            readCl.gone()
                        extemporeCl.visible()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("[conversation", ignoreCase = true)) {
//            readCl.gone()
                        extemporeCl.gone()
                        conversationsCl.visible()
                    }


//          sreCl.visible()
//          othCl.visible()
                }

                R.string.decision_bad -> {
                    decisionGroup.check(decisionBadBtn.id)
                    commonCl1.visible()
                    commonCl2.visible()
                    commonCl3.visible()
                    commonCl4.visible()
                    commentCl.visible()


                    if (viewModel.task.name.contains("[read]", ignoreCase = true)) {
//            readCl.visible()
                        extemporeCl.gone()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("extempore", ignoreCase = true)) {
//            readCl.gone()
                        extemporeCl.visible()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("[conversation", ignoreCase = true)) {
//            readCl.gone()
                        extemporeCl.gone()
                        conversationsCl.visible()
                    }
//          vncCl.visible()
////          othCl.visible()
//          commentCl.visible()
//          sreCl.visible()
////          othCl.visible()
                }

                R.string.decision_excellent -> {
                    decisionGroup.check(decisionExcellentBtn.id)
                    commonCl1.gone()
                    commonCl2.gone()
                    commonCl3.gone()
                    commonCl4.gone()
                    commentCl.gone()
//          readCl.gone()
                    extemporeCl.gone()
                    conversationsCl.gone()
//          vncCl.gone()
//          othCl.gone()
//          commentCl.gone()
//          sreCl.gone()
//          othCl.gone()
                }

                else -> decisionGroup.clearChecked()
            }
        }

        viewModel.commentTickHandler.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { value ->
            if (value) {
                textComment.enable()
            } else {
                textComment.text?.clear()
                textComment.disable()
            }
        }


//    viewModel.volumeTickHandler.observe(
//      viewLifecycleOwner.lifecycle, viewLifecycleScope
//    ) { value ->
//      Log.e("VOLUME_OBSERVE",value.toString())
//      viewModel.handlevolumeTickChange(value)
//    }

//    viewModel.volumeRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.volume_bad -> volumeGroup.check(volumeBadBtn.id)
//        R.string.volume_okay -> volumeGroup.check(volumeOkayBtn.id)
//        else -> volumeGroup.clearChecked()
//      }
//    }
//    viewModel.bgNoiseRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.bgNoise_bad -> bgNoiseGroup.check(bgNoiseBadBtn.id)
//        R.string.bgNoise_okay -> bgNoiseGroup.check(bgNoiseOkayBtn.id)
//        else -> bgNoiseGroup.clearChecked()
//      }
//    }
//
//    viewModel.cSwitchRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.cSwitching_bad -> cSwitchingGroup.check(cSwitchingBadBtn.id)
//        R.string.cSwitching_okay -> cSwitchingGroup.check(cSwitchingOkayBtn.id)
//        else -> cSwitchingGroup.clearChecked()
//      }
//    }
//    viewModel.bgChatterRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.bgChatter_bad -> bgChatterGroup.check(bgChatterBadBtn.id)
//        R.string.bgChatter_okay -> bgChatterGroup.check(bgChatterOkayBtn.id)
//        else -> bgChatterGroup.clearChecked()
//      }
//    }
//
//    viewModel.voLapRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.volap_bad -> volapGroup.check(volapBadBtn.id)
//        R.string.volap_okay -> volapGroup.check(volapOkayBtn.id)
//        else -> volapGroup.clearChecked()
//      }
//    }
//    viewModel.sstRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.sst_bad -> sstGroup.check(sstBadBtn.id)
//        R.string.sst_okay -> sstGroup.check(sstOkayBtn.id)
//        else -> sstGroup.clearChecked()
//      }
//    }
//    viewModel.handleReadQRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.readQuality_bad -> readQualityGroup.check(readQualityBadBtn.id)
//        R.string.readQuality_okay -> readQualityGroup.check(readQualityOkayBtn.id)
//        else -> readQualityGroup.clearChecked()
//      }
//    }
//    viewModel.handleExtemporeQRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        R.string.extemporeQuality_bad -> extemporeQualityGroup.check(extemporeQualityBadBtn.id)
//        R.string.extemporeQuality_okay -> extemporeQualityGroup.check(extemporeQualityOkayBtn.id)
//        else -> extemporeQualityGroup.clearChecked()
//      }
//    }

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
//    accuracyGoodBtn.enable()
//    accuracyOkayBtn.enable()
//    accuracyBadBtn.enable()
//
//    qualityGoodBtn.enable()
//    qualityOkayBtn.enable()
//    qualityBadBtn.enable()

//    volumeGoodBtn.enable()

        decisionBadBtn.enable()
        decisionExcellentBtn.enable()
        decisionOkayBtn.enable()

        volumeTick.enable()
        objContTick.enable()
        skippingWordsTick.enable()
        incorrectTextTick.enable()
        factualInaccuracyTick.enable()
        wrongLang.enable()
        echoTick.enable()
        wrongGender.enable()
        wrongAgeGroup.enable()
//    miscTick.enable()

//    noiseTick.enable()
//    chatterTick.enable()
        noiseTickIntermittent.enable()
        chatterTickIntermittent.enable()
        noiseTickPersistent.enable()
        chatterTickPersistent.enable()
        unclearAudioTick.enable()

        notOnTopicTick.enable()
        repContentTick.enable()
        longPausesTick.enable()

        misPronTick.enable()

        readPromptTick.enable()
        bookReadTick.enable()

        sstTick.enable()
        stretchingTick.enable()
//    readQTick.enable()
        badExtemporeTick.enable()
        textComment.enable()
        otherTick.enable()
//    volumeOkayBtn.enable()
//    volumeBadBtn.enable()
//
//    bgNoiseBadBtn.enable()
//    bgNoiseOkayBtn.enable()
//
//    cSwitchingBadBtn.enable()
//    cSwitchingOkayBtn.enable()
//
//    bgChatterBadBtn.enable()
//    bgChatterOkayBtn.enable()
//
//    volapBadBtn.enable()
//    volapOkayBtn.enable()
//
//    sstBadBtn.enable()
//    sstOkayBtn.enable()
//
//
//    readQualityBadBtn.enable()
//    readQualityOkayBtn.enable()
//
//    extemporeQualityBadBtn.enable()
//    extemporeQualityOkayBtn.enable()

//    commentCl.enable()

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

        decisionBadBtn.disable()
        decisionExcellentBtn.disable()
        decisionOkayBtn.disable()
//    miscTick.disable()

        objContTick.disable()
        skippingWordsTick.disable()
        incorrectTextTick.disable()
        factualInaccuracyTick.disable()

        volumeTick.disable()
//    noiseTick.disable()
//    chatterTick.disable()
        noiseTickIntermittent.disable()
        chatterTickIntermittent.disable()
        noiseTickPersistent.disable()
        chatterTickPersistent.disable()
        unclearAudioTick.disable()
        unclearAudioTick.disable()

        notOnTopicTick.disable()
        repContentTick.disable()
        longPausesTick.disable()

        misPronTick.disable()

        readPromptTick.disable()
        bookReadTick.disable()

        sstTick.disable()
        stretchingTick.disable()
//    readQTick.disable()
        badExtemporeTick.disable()
        textComment.disable()
        otherTick.disable()
        wrongLang.disable()
        echoTick.disable()

        wrongGender.disable()
        wrongAgeGroup.disable()
//    volumeOkayBtn.disable()
//    volumeBadBtn.disable()
//
//    bgNoiseBadBtn.disable()
//    bgNoiseOkayBtn.disable()
//
//    cSwitchingBadBtn.disable()
//    cSwitchingOkayBtn.disable()
//
//    bgChatterBadBtn.disable()
//    bgChatterOkayBtn.disable()
//
//    volapBadBtn.disable()
//    volapOkayBtn.disable()
//
//    sstBadBtn.disable()
//    sstOkayBtn.disable()
//
//    readQualityBadBtn.disable()
//    readQualityOkayBtn.disable()
//
//    extemporeQualityBadBtn.disable()
//    extemporeQualityOkayBtn.disable()

//    commentCl.disable()
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

    override fun onProgressChanged(p0: SeekBar?, p1: Int, p2: Boolean) {
        viewModel.handleSeekBarChange(p1, p2)
//    viewModel.updatePlaybackProgress(5)
//    Log.e("OnProgressChange",p1.toString()+" "+p2.toString())
    }

    override fun onStartTrackingTouch(p0: SeekBar?) {

//    Log.e("OnStartTracking","Start Tracking"+p0.toString())

    }

    override fun onStopTrackingTouch(p0: SeekBar?) {
//    Log.e("OnStopTracking","Start Tracking"+p0.toString())
    }

}
