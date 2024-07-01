package com.ai4bharat.kathbath.ui.scenarios.speechVerificationMultiModal

import android.app.AlertDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SeekBar
import androidx.activity.addCallback
import androidx.core.view.get
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.kathbath.utils.extensions.disable
import com.ai4bharat.kathbath.utils.extensions.enable
import com.ai4bharat.kathbath.utils.extensions.gone
import com.ai4bharat.kathbath.utils.extensions.observe
import com.ai4bharat.kathbath.utils.extensions.viewLifecycleScope
import com.ai4bharat.kathbath.utils.extensions.visible
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_common_back_button.view.backIv
import kotlinx.android.synthetic.main.microtask_common_next_button.view.nextIv
import kotlinx.android.synthetic.main.microtask_common_playback_progress.progressPb
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.centiSecondsTv
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.progressPb
import kotlinx.android.synthetic.main.microtask_common_playback_progress.view.secondsTv
import kotlinx.android.synthetic.main.microtask_speech_verification.conversationsCl
import kotlinx.android.synthetic.main.microtask_speech_verification.extemporeCl
import kotlinx.android.synthetic.main.microtask_speech_verification.textComment
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.inputPromptViewPager
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationaudioDuplicateSpeaker
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationbackBtn
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationbadExtemporeTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationbookReadTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationchatterTickIntermittent
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationchatterTickPersistent
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationcommentCl
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationcommonCl1
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationcommonCl2
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationcommonCl3
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationcommonCl4
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationconversationsCl
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationdecisionBadBtn
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationdecisionExcellentBtn
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationdecisionGroup
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationdecisionOkayBtn
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationechoTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationextemporeCl
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationfactualInaccuracyTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationincorrectTextTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationlongPausesTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationmisPronTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationnextBtnCv
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationnoiseTickIntermittent
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationnoiseTickPersistent
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationnotOnTopicTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationobjContTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationotherTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationplayBtn
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationplaybackProgress
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationreadPromptTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationrepContentTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationskippingWordsTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationsstTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationstretchingTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationtextComment
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationunclearAudioTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationvolumeTick
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationwrongAgeGroup
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationwrongGender
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.microtaskMultiModalSpeechVerificationwrongLang


@AndroidEntryPoint
class SpeechVerificationMultiModalFragment :
    BaseMTRendererFragment(R.layout.microtask_speech_verification_multi_modal),
    SeekBar.OnSeekBarChangeListener {

    override val viewModel: SpeechVerificationMultiModalViewModel by viewModels()
    val args: SpeechVerificationMultiModalFragmentArgs by navArgs()
    private lateinit var verificationInputPromptAdapter: InputPromptAdapter
    private lateinit var tabLayout: TabLayout
    private var audioPromptFragment: InputPromptAudioFragment = InputPromptAudioFragment("")
    private var audioResponceFragment: InputPromptAudioFragment = InputPromptAudioFragment("")
    private var imagePromptFragment: InputPromptImageFragment = InputPromptImageFragment("")
    private var textPromptFragment: InputPromptTextFragment = InputPromptTextFragment("")


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = super.onCreateView(inflater, container, savedInstanceState)
        viewModel.setupViewModel(args.taskId, args.completed, args.total)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        tabLayout = view.findViewById(R.id.inputPromptTabLayout)
        setupObservers()
        microtaskMultiModalSpeechVerificationplayBtn.setOnClickListener { viewModel.handlePlayClick() }
        microtaskMultiModalSpeechVerificationnextBtnCv.setOnClickListener {
            audioPromptFragment.releasePlayer()
            audioResponceFragment.releasePlayer()
            viewModel.handleNextClick()
        }

        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) {
            audioPromptFragment.releasePlayer()
            viewModel.onBackPressed()
        }

        with(viewModel) {
            microtaskMultiModalSpeechVerificationdecisionGroup.addOnButtonCheckedListener { group, checkedId, isChecked ->
                if (isChecked) {
                    when (checkedId) {
                        microtaskMultiModalSpeechVerificationdecisionBadBtn.id -> handleDecisionChange(
                            R.string.decision_bad
                        )

                        microtaskMultiModalSpeechVerificationdecisionExcellentBtn.id -> handleDecisionChange(
                            R.string.decision_excellent
                        )

                        microtaskMultiModalSpeechVerificationdecisionOkayBtn.id -> handleDecisionChange(
                            R.string.decision_okay
                        )
                    }
                    microtaskMultiModalSpeechVerificationtextComment.disable()
                }
            }

            microtaskMultiModalSpeechVerificationvolumeTick.setOnCheckedChangeListener { _, b ->
                handleVolumeTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationnoiseTickIntermittent.setOnCheckedChangeListener { _, b ->
                handleNoiseTickIntermittentChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationchatterTickIntermittent.setOnCheckedChangeListener { _, b ->
                handleChatterTickIntermittentChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationnoiseTickPersistent.setOnCheckedChangeListener { _, b ->
                handleNoiseTickPersistentChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationchatterTickPersistent.setOnCheckedChangeListener { _, b ->
                handleChatterTickPersistentChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationunclearAudioTick.setOnCheckedChangeListener { _, b ->
                handleUnclearAudioTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationobjContTick.setOnCheckedChangeListener { _, b ->
                handleObjContTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationskippingWordsTick.setOnCheckedChangeListener { _, b ->
                handleSkippingWordsTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationincorrectTextTick.setOnCheckedChangeListener { _, b ->
                handleIncorrectTextTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationfactualInaccuracyTick.setOnCheckedChangeListener { _, b ->
                handleFactualInaccuracyTick(
                    b
                )
            }

            microtaskMultiModalSpeechVerificationnotOnTopicTick.setOnCheckedChangeListener { _, b ->
                handleNotOnTopicTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationrepContentTick.setOnCheckedChangeListener { _, b ->
                handleRepContentTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationlongPausesTick.setOnCheckedChangeListener { _, b ->
                handleLongPausesTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationstretchingTick.setOnCheckedChangeListener { _, b ->
                handleStretchingTickChange(
                    b
                )
            }

            microtaskMultiModalSpeechVerificationmisPronTick.setOnCheckedChangeListener { _, b ->
                handleMisPronTickChange(
                    b
                )
            }


            microtaskMultiModalSpeechVerificationreadPromptTick.setOnCheckedChangeListener { _, b ->
                handleReadPromptTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationbookReadTick.setOnCheckedChangeListener { _, b ->
                handleBookReadTickChange(
                    b
                )
            }

            microtaskMultiModalSpeechVerificationsstTick.setOnCheckedChangeListener { _, b ->
                handleSSTTickChange(
                    b
                )
            }
//      readQTick.setOnCheckedChangeListener { _, b -> handleReadQTickChange(b) }
            microtaskMultiModalSpeechVerificationbadExtemporeTick.setOnCheckedChangeListener { _, b ->
                handleBadExtemporeTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationotherTick.setOnCheckedChangeListener { _, b ->
                handleCommentsTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationwrongLang.setOnCheckedChangeListener { _, b ->
                handleWrongLangTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationechoTick.setOnCheckedChangeListener { _, b ->
                handleEchoTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationwrongGender.setOnCheckedChangeListener { _, b ->
                handleWrongGenderTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationwrongAgeGroup.setOnCheckedChangeListener { _, b ->
                handleWrongAgeGroupTickChange(
                    b
                )
            }
            microtaskMultiModalSpeechVerificationaudioDuplicateSpeaker.setOnCheckedChangeListener { _, b ->
                handleDuplicateSpeakerTickChange(
                    b
                )
            }

            microtaskMultiModalSpeechVerificationtextComment.addTextChangedListener(
                microtaskMultiModalSpeechVerificationtextComment.doAfterTextChanged { text ->
                    handleCommentTextChange(
                        text.toString()
                    )
                })

            microtaskMultiModalSpeechVerificationplaybackProgress.progressPb.setOnSeekBarChangeListener(
                this@SpeechVerificationMultiModalFragment
            )
        }

    }

    private fun setupObservers() {
        viewModel.inputPrompt.observe(viewLifecycleOwner.lifecycle, lifecycleScope) { promptInfo ->
            println("NEW ASSIG# changed")
            setupInputPrompts(promptInfo)
        }

        viewModel.microtaskID.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { id ->
            microtaskMultiModalSpeechVerificationaudioDuplicateSpeaker.isChecked = false
            microtaskMultiModalSpeechVerificationwrongLang.isChecked = false
            microtaskMultiModalSpeechVerificationechoTick.isChecked = false
            microtaskMultiModalSpeechVerificationobjContTick.isChecked = false
            microtaskMultiModalSpeechVerificationwrongGender.isChecked = false
            microtaskMultiModalSpeechVerificationwrongAgeGroup.isChecked = false
            microtaskMultiModalSpeechVerificationskippingWordsTick.isChecked = false
            microtaskMultiModalSpeechVerificationincorrectTextTick.isChecked = false
            microtaskMultiModalSpeechVerificationfactualInaccuracyTick.isChecked = false
            microtaskMultiModalSpeechVerificationvolumeTick.isChecked = false
            microtaskMultiModalSpeechVerificationnoiseTickIntermittent.isChecked = false
            microtaskMultiModalSpeechVerificationchatterTickIntermittent.isChecked = false
            microtaskMultiModalSpeechVerificationnoiseTickPersistent.isChecked = false
            microtaskMultiModalSpeechVerificationchatterTickPersistent.isChecked = false
            microtaskMultiModalSpeechVerificationunclearAudioTick.isChecked = false
            microtaskMultiModalSpeechVerificationnotOnTopicTick.isChecked = false
            microtaskMultiModalSpeechVerificationrepContentTick.isChecked = false
            microtaskMultiModalSpeechVerificationlongPausesTick.isChecked = false
            microtaskMultiModalSpeechVerificationmisPronTick.isChecked = false
            microtaskMultiModalSpeechVerificationreadPromptTick.isChecked = false
            microtaskMultiModalSpeechVerificationbookReadTick.isChecked = false
            microtaskMultiModalSpeechVerificationsstTick.isChecked = false
            microtaskMultiModalSpeechVerificationstretchingTick.isChecked = false
            microtaskMultiModalSpeechVerificationcommonCl1.gone()
            microtaskMultiModalSpeechVerificationcommonCl2.gone()
            microtaskMultiModalSpeechVerificationcommonCl3.gone()
            microtaskMultiModalSpeechVerificationcommonCl4.gone()
            microtaskMultiModalSpeechVerificationextemporeCl.gone()
            microtaskMultiModalSpeechVerificationconversationsCl.gone()
            microtaskMultiModalSpeechVerificationcommentCl.gone()

        }

        viewModel.playbackSecondsTvText.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            microtaskMultiModalSpeechVerificationplaybackProgress.secondsTv.text = text
        }

        viewModel.playbackCentiSecondsTvText.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { text ->
            microtaskMultiModalSpeechVerificationplaybackProgress.centiSecondsTv.text = text
        }

        viewModel.playbackProgressPbMax.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { max ->
            microtaskMultiModalSpeechVerificationplaybackProgress.progressPb.max = max
        }

        viewModel.playbackProgress.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { progress ->
            microtaskMultiModalSpeechVerificationplaybackProgress.progressPb.progress = progress
        }

        viewModel.navAndMediaBtnGroup.observe(
            viewLifecycleOwner.lifecycle, viewLifecycleScope
        ) { states ->
            flushButtonStates(states.first, states.second, states.third)
        }


        viewModel.decisionRating.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { value ->


            when (value) {
                R.string.decision_okay -> {
                    microtaskMultiModalSpeechVerificationdecisionGroup.check(
                        microtaskMultiModalSpeechVerificationdecisionOkayBtn.id
                    )
                    microtaskMultiModalSpeechVerificationcommonCl1.visible()
                    microtaskMultiModalSpeechVerificationcommonCl2.visible()
                    microtaskMultiModalSpeechVerificationcommonCl3.visible()
                    microtaskMultiModalSpeechVerificationcommonCl4.visible()
                    microtaskMultiModalSpeechVerificationcommentCl.visible()

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
                }

                R.string.decision_bad -> {
                    microtaskMultiModalSpeechVerificationdecisionGroup.check(
                        microtaskMultiModalSpeechVerificationdecisionBadBtn.id
                    )
                    microtaskMultiModalSpeechVerificationcommonCl1.visible()
                    microtaskMultiModalSpeechVerificationcommonCl2.visible()
                    microtaskMultiModalSpeechVerificationcommonCl3.visible()
                    microtaskMultiModalSpeechVerificationcommonCl4.visible()
                    microtaskMultiModalSpeechVerificationcommentCl.visible()


                    if (viewModel.task.name.contains("[read]", ignoreCase = true)) {
                        extemporeCl.gone()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("extempore", ignoreCase = true)) {
                        extemporeCl.visible()
                        conversationsCl.gone()
                    } else if (viewModel.task.name.contains("[conversation", ignoreCase = true)) {
                        extemporeCl.gone()
                        conversationsCl.visible()
                    }
                }

                R.string.decision_excellent -> {
                    microtaskMultiModalSpeechVerificationdecisionGroup.check(
                        microtaskMultiModalSpeechVerificationdecisionExcellentBtn.id
                    )
                    microtaskMultiModalSpeechVerificationcommonCl1.gone()
                    microtaskMultiModalSpeechVerificationcommonCl2.gone()
                    microtaskMultiModalSpeechVerificationcommonCl3.gone()
                    microtaskMultiModalSpeechVerificationcommonCl4.gone()
                    microtaskMultiModalSpeechVerificationcommentCl.gone()
                    microtaskMultiModalSpeechVerificationextemporeCl.gone()
                    microtaskMultiModalSpeechVerificationconversationsCl.gone()

                }

                else -> microtaskMultiModalSpeechVerificationdecisionGroup.clearChecked()
            }
        }

        viewModel.commentTickHandler.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { value ->
            if (value) {
                microtaskMultiModalSpeechVerificationtextComment.enable()
            } else {
                microtaskMultiModalSpeechVerificationtextComment.text?.clear()
                microtaskMultiModalSpeechVerificationtextComment.disable()
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

    private fun flushButtonStates(
        backBtnState: AudioRecorderButtonState,
        playBtnState: AudioRecorderButtonState,
        nextBtnState: AudioRecorderButtonState
    ) {
        microtaskMultiModalSpeechVerificationplayBtn.isClickable =
            playBtnState != AudioRecorderButtonState.DISABLED
        microtaskMultiModalSpeechVerificationbackBtn.isClickable =
            backBtnState != AudioRecorderButtonState.DISABLED
        microtaskMultiModalSpeechVerificationnextBtnCv.isClickable =
            nextBtnState != AudioRecorderButtonState.DISABLED

        microtaskMultiModalSpeechVerificationplayBtn.setBackgroundResource(
            when (playBtnState) {
                AudioRecorderButtonState.DISABLED -> R.drawable.ic_speaker_disabled
                AudioRecorderButtonState.ENABLED -> R.drawable.ic_speaker_enabled
                AudioRecorderButtonState.ACTIVE -> R.drawable.ic_speaker_active
            }
        )

        microtaskMultiModalSpeechVerificationnextBtnCv.nextIv.setBackgroundResource(
            when (nextBtnState) {
                AudioRecorderButtonState.DISABLED -> R.drawable.ic_next_disabled
                AudioRecorderButtonState.ENABLED -> R.drawable.ic_next_enabled
                AudioRecorderButtonState.ACTIVE -> R.drawable.ic_next_enabled
            }
        )

        microtaskMultiModalSpeechVerificationbackBtn.backIv.setBackgroundResource(
            when (backBtnState) {
                AudioRecorderButtonState.DISABLED -> R.drawable.ic_back_disabled
                AudioRecorderButtonState.ENABLED -> R.drawable.ic_back_enabled
                AudioRecorderButtonState.ACTIVE -> R.drawable.ic_back_enabled
            }
        )
    }

    private fun setupInputPrompts(
        promptInfo: Map<String, String>
    ) {
        val audioPromptFilePath = promptInfo["audio_prompt"]
        val audioResponseFilePath = promptInfo["audio_response"]
        val audioImageFilePath = promptInfo["image"]
        val sentence = promptInfo["sentence"]

        var tabTitles: MutableList<String> = mutableListOf()

        println("NEW ASSIG $promptInfo")

        val verificationInputPromptAdapter = InputPromptAdapter(requireParentFragment())
        if (audioPromptFilePath != "") {
            audioPromptFragment = InputPromptAudioFragment(audioPromptFilePath!!)
            verificationInputPromptAdapter.addFragment(audioPromptFragment)
            tabTitles.add("Audio prompt")

            audioPromptFragment.mediaPlayerStatus.observe(viewLifecycleOwner) {
                if (it == InputAudioPlayerState.PLAYING) {
                    microtaskMultiModalSpeechVerificationplayBtn.isClickable = false
                    microtaskMultiModalSpeechVerificationplayBtn.setBackgroundResource(R.drawable.ic_speaker_disabled)

                } else {
                    microtaskMultiModalSpeechVerificationplayBtn.isClickable = true
                    microtaskMultiModalSpeechVerificationplayBtn.setBackgroundResource(R.drawable.ic_speaker_enabled)
                }
            }

        }

        if (audioResponseFilePath != "") {
            audioResponceFragment = InputPromptAudioFragment(audioResponseFilePath!!)
            verificationInputPromptAdapter.addFragment(audioResponceFragment)
            tabTitles.add("Audio response")

            audioResponceFragment.mediaPlayerStatus.observe(viewLifecycleOwner) {
                if (it == InputAudioPlayerState.PLAYING) {
                    microtaskMultiModalSpeechVerificationplayBtn.isClickable = false
                    microtaskMultiModalSpeechVerificationplayBtn.setBackgroundResource(R.drawable.ic_speaker_disabled)

                } else {
                    microtaskMultiModalSpeechVerificationplayBtn.isClickable = true
                    microtaskMultiModalSpeechVerificationplayBtn.setBackgroundResource(R.drawable.ic_speaker_enabled)
                }
            }

        }

        if (audioImageFilePath != "") {
            imagePromptFragment = InputPromptImageFragment(audioImageFilePath!!)
            verificationInputPromptAdapter.addFragment(imagePromptFragment)
            tabTitles.add("Image")
        }

        if (sentence != "") {
            textPromptFragment = InputPromptTextFragment(sentence!!)
            verificationInputPromptAdapter.addFragment(textPromptFragment)
            tabTitles.add("Sentence")
        }

        inputPromptViewPager.adapter = verificationInputPromptAdapter

        TabLayoutMediator(tabLayout, inputPromptViewPager) { tab, position ->
            tab.text = tabTitles[position]
        }.attach()
    }

    private fun enableReviewing() {

        microtaskMultiModalSpeechVerificationdecisionBadBtn.enable()
        microtaskMultiModalSpeechVerificationdecisionExcellentBtn.enable()
        microtaskMultiModalSpeechVerificationdecisionOkayBtn.enable()
        microtaskMultiModalSpeechVerificationvolumeTick.enable()
        microtaskMultiModalSpeechVerificationobjContTick.enable()
        microtaskMultiModalSpeechVerificationskippingWordsTick.enable()
        microtaskMultiModalSpeechVerificationincorrectTextTick.enable()
        microtaskMultiModalSpeechVerificationfactualInaccuracyTick.enable()
        microtaskMultiModalSpeechVerificationwrongLang.enable()
        microtaskMultiModalSpeechVerificationechoTick.enable()
        microtaskMultiModalSpeechVerificationwrongGender.enable()
        microtaskMultiModalSpeechVerificationwrongAgeGroup.enable()
        microtaskMultiModalSpeechVerificationnoiseTickIntermittent.enable()
        microtaskMultiModalSpeechVerificationchatterTickIntermittent.enable()
        microtaskMultiModalSpeechVerificationnoiseTickPersistent.enable()
        microtaskMultiModalSpeechVerificationchatterTickPersistent.enable()
        microtaskMultiModalSpeechVerificationunclearAudioTick.enable()
        microtaskMultiModalSpeechVerificationnotOnTopicTick.enable()
        microtaskMultiModalSpeechVerificationrepContentTick.enable()
        microtaskMultiModalSpeechVerificationlongPausesTick.enable()
        microtaskMultiModalSpeechVerificationmisPronTick.enable()
        microtaskMultiModalSpeechVerificationreadPromptTick.enable()
        microtaskMultiModalSpeechVerificationbookReadTick.enable()
        microtaskMultiModalSpeechVerificationsstTick.enable()
        microtaskMultiModalSpeechVerificationstretchingTick.enable()
        microtaskMultiModalSpeechVerificationbadExtemporeTick.enable()
        microtaskMultiModalSpeechVerificationtextComment.enable()
        microtaskMultiModalSpeechVerificationotherTick.enable()
    }

    private fun disableReview() {
        microtaskMultiModalSpeechVerificationdecisionBadBtn.disable()
        microtaskMultiModalSpeechVerificationdecisionExcellentBtn.disable()
        microtaskMultiModalSpeechVerificationdecisionOkayBtn.disable()
        microtaskMultiModalSpeechVerificationobjContTick.disable()
        microtaskMultiModalSpeechVerificationskippingWordsTick.disable()
        microtaskMultiModalSpeechVerificationincorrectTextTick.disable()
        microtaskMultiModalSpeechVerificationfactualInaccuracyTick.disable()
        microtaskMultiModalSpeechVerificationvolumeTick.disable()
        microtaskMultiModalSpeechVerificationnoiseTickIntermittent.disable()
        microtaskMultiModalSpeechVerificationchatterTickIntermittent.disable()
        microtaskMultiModalSpeechVerificationnoiseTickPersistent.disable()
        microtaskMultiModalSpeechVerificationchatterTickPersistent.disable()
        microtaskMultiModalSpeechVerificationunclearAudioTick.disable()
        microtaskMultiModalSpeechVerificationunclearAudioTick.disable()
        microtaskMultiModalSpeechVerificationnotOnTopicTick.disable()
        microtaskMultiModalSpeechVerificationrepContentTick.disable()
        microtaskMultiModalSpeechVerificationlongPausesTick.disable()
        microtaskMultiModalSpeechVerificationmisPronTick.disable()
        microtaskMultiModalSpeechVerificationreadPromptTick.disable()
        microtaskMultiModalSpeechVerificationbookReadTick.disable()
        microtaskMultiModalSpeechVerificationsstTick.disable()
        microtaskMultiModalSpeechVerificationstretchingTick.disable()
        microtaskMultiModalSpeechVerificationbadExtemporeTick.disable()
        microtaskMultiModalSpeechVerificationtextComment.disable()
        microtaskMultiModalSpeechVerificationotherTick.disable()
        microtaskMultiModalSpeechVerificationwrongLang.disable()
        microtaskMultiModalSpeechVerificationechoTick.disable()
        microtaskMultiModalSpeechVerificationwrongGender.disable()
        microtaskMultiModalSpeechVerificationwrongAgeGroup.disable()

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

    override fun onProgressChanged(p0: SeekBar?, p1: Int, p2: Boolean) {
        println("SVMMFKT $p1 $p2")
        viewModel.handleSeekBarChange(p1, p2)
    }

    override fun onStartTrackingTouch(p0: SeekBar?) {
    }

    override fun onStopTrackingTouch(p0: SeekBar?) {
    }

}
























