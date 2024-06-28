package com.ai4bharat.kathbath.ui.scenarios.speechVerificationMultiModal

import android.graphics.BitmapFactory
import android.media.MediaPlayer
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.utils.DateTimeUtils
import kotlinx.android.synthetic.main.verification_input_prompt_audio_element.verificationAudioPromptCurrentTime
import kotlinx.android.synthetic.main.verification_input_prompt_audio_element.verificationAudioPromptProgressBar
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import okhttp3.internal.wait
import kotlin.coroutines.coroutineContext

class InputPromptAdapter(fragment: Fragment) : FragmentStateAdapter(fragment) {

    private val fragmentList: ArrayList<Fragment> = arrayListOf()

    override fun createFragment(position: Int): Fragment {
        return fragmentList[position]
    }

    override fun onDetachedFromRecyclerView(recyclerView: RecyclerView) {
        super.onDetachedFromRecyclerView(recyclerView)
    }

    fun addFragment(fragment: Fragment) {
        fragmentList.add(fragment)
    }

    override fun getItemCount(): Int {
        // Change this
        return fragmentList.size
    }
}


class InputPromptAudioFragment(private val audioFilePath: String) : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_audio_element, container, false)
    }

    private var mediaPlayer: MediaPlayer = MediaPlayer()
    var mediaPlayerStatus =
        MutableLiveData<InputAudioPlayerState>(InputAudioPlayerState.DISABLED)
    private var updateTimeStampJob: Job? = null
    private lateinit var playPauseButton: ImageButton
    private lateinit var currentTimeStamp: TextView
    private lateinit var totalTimeStamp: TextView

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        playPauseButton = view.findViewById(R.id.verificationAudioPromptPlayButton)
        currentTimeStamp = view.findViewById(R.id.verificationAudioPromptCurrentTime)
        totalTimeStamp = view.findViewById(R.id.verificationAudioPromptTotalTime)

        if (audioFilePath == "") {
            return
        }

        prepareMediaPlayer()
        setupObserver()

        mediaPlayer.setOnPreparedListener {
            totalTimeStamp.text = DateTimeUtils.millisecondToTime(it.duration.toDouble())
            mediaPlayerStatus.value = InputAudioPlayerState.PREPARED
        }
        mediaPlayer.setOnCompletionListener {
            currentTimeStamp.text = DateTimeUtils.millisecondToTime(it.duration.toDouble())
            updateTimeStampJob?.cancel()
            mediaPlayerStatus.value = InputAudioPlayerState.FINISHED
            verificationAudioPromptProgressBar.progress = 100
        }

        playPauseButton.setOnClickListener {
            println("VIPV the status is ${mediaPlayerStatus.value}")
            when (mediaPlayerStatus.value) {
                InputAudioPlayerState.FINISHED,
                InputAudioPlayerState.PREPARED,
                InputAudioPlayerState.PAUSED -> {
                    mediaPlayer.start()
                    mediaPlayerStatus.value = InputAudioPlayerState.PLAYING
                    startTimestampUpdateJob()
                }

                InputAudioPlayerState.PLAYING -> {
                    mediaPlayer.pause()
                    mediaPlayerStatus.value = InputAudioPlayerState.PAUSED
                    updateTimeStampJob?.cancel()
                }

                InputAudioPlayerState.DISABLED,
                InputAudioPlayerState.RELEASED -> {
                    prepareMediaPlayer()
                }

                else -> {

                }
            }
        }

    }

    private fun startTimestampUpdateJob() {
        updateTimeStampJob = lifecycleScope.launch {
            while (true) {
                currentTimeStamp.text =
                    DateTimeUtils.millisecondToTime(mediaPlayer.currentPosition.toDouble())
                delay(500)
                verificationAudioPromptProgressBar.progress =
                    DateTimeUtils.millisecondToPercentage(
                        mediaPlayer.currentPosition.toDouble(),
                        mediaPlayer.duration.toDouble()
                    )
            }
        }
    }

    private fun setupObserver() {
        mediaPlayerStatus.observe(viewLifecycleOwner) { mediaPlayerStatus ->
            when (mediaPlayerStatus) {
                InputAudioPlayerState.PLAYING -> playPauseButton.setBackgroundResource(R.drawable.baseline_pause_circle_outline_24)
                else -> playPauseButton.setBackgroundResource(R.drawable.baseline_play_circle_outline_24)
            }
        }
    }

    private fun prepareMediaPlayer() {
        mediaPlayer = MediaPlayer()
        mediaPlayer.setDataSource(audioFilePath)
        mediaPlayer.prepare()
        mediaPlayer.setOnPreparedListener {
            it.start()
            mediaPlayerStatus.value = InputAudioPlayerState.PLAYING
            startTimestampUpdateJob()
        }
    }

    fun releasePlayer() {
        updateTimeStampJob?.cancel()
        mediaPlayer.release()
        mediaPlayerStatus.value = InputAudioPlayerState.RELEASED
    }

}


class InputPromptImageFragment(val imageFilePath: String) : Fragment() {

    val test = MutableLiveData<Int>()
    private lateinit var imageView: ImageView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_image_element, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        println("VIPV $imageFilePath")

        imageView = view.findViewById(R.id.verificationImagePromptImageView)
        val bitmapFactory = BitmapFactory.decodeFile(imageFilePath)
        imageView.setImageBitmap(bitmapFactory)

    }
}


class InputPromptTextFragment(val sentence: String) : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_text_element, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val textView: TextView = view.findViewById(R.id.verificationTextPromptSentence)

        textView.setText(sentence)

    }
}






















