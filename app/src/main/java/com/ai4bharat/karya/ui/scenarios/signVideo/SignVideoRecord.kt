package com.ai4bharat.karya.ui.scenarios.signVideo

import android.Manifest
import android.content.ContentValues
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.video.FileOutputOptions
import androidx.camera.video.MediaStoreOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.camera.video.VideoRecordEvent
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.core.content.PermissionChecker
import com.ai4bharat.karya.R
import com.ai4bharat.karya.utils.extensions.invisible
import com.ai4bharat.karya.utils.extensions.visible
import com.vincent.videocompressor.VideoCompress
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class SignVideoRecord : AppCompatActivity() {

    private lateinit var videoFilePath: String
    private lateinit var scratchVideoFilePath: String
    private lateinit var viewFinder: PreviewView
    private lateinit var startRecordingButton: Button
    private lateinit var videoCapture: VideoCapture<Recorder>
    private lateinit var innerVideoTextView2: TextView
    private lateinit var compressionProgress: ProgressBar
    private var recording: Recording? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.fragment_sign_video_record_2)

        viewFinder = findViewById<PreviewView>(R.id.viewFinder)
        startRecordingButton = findViewById<Button>(R.id.video_capture_button)
        innerVideoTextView2 = findViewById<TextView>(R.id.innerVideoTextView2)
        compressionProgress = findViewById(R.id.compressionProgress2)

        innerVideoTextView2.text = intent.getStringExtra("sentence")!!
        innerVideoTextView2.movementMethod = ScrollingMovementMethod()

        prepareCamera()
        startRecordingButton.setOnClickListener {
            captureVideo()
        }
    }

    private fun prepareCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            // Used to bind the lifecycle of cameras to the lifecycle owner
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()

            // Preview
            val preview = Preview.Builder()
                .build()
                .also {
                    it.setSurfaceProvider(viewFinder.surfaceProvider)
                }

            val recorder = Recorder.Builder()
                .setQualitySelector(QualitySelector.from(Quality.HIGHEST))
                .build()
            videoCapture = VideoCapture.withOutput(recorder)

            // Select back camera as a default
            val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA

            try {
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

                // Bind use cases to camera
                cameraProvider
                    .bindToLifecycle(this, cameraSelector, preview, videoCapture)
            } catch (exc: Exception) {
                Log.e("NEW CAMERA", "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }

    // Implements VideoCapture use case, including start and stop capturing.
    private fun captureVideo() {
        val videoCapture = this.videoCapture ?: return
        videoFilePath = intent.getStringExtra("video_file_path")!!
        scratchVideoFilePath = "${videoFilePath}.scratch.mp4"
        val scratchVideoFile = File(scratchVideoFilePath)


        val curRecording = recording
        if (curRecording != null) {
            // Stop the current recording session.
            curRecording.stop()
            recording = null
            return
        }

        val fileOutputOptions = FileOutputOptions.Builder(scratchVideoFile).build()
        recording = videoCapture.output
            .prepareRecording(this, fileOutputOptions)
            .apply {
                if (PermissionChecker.checkSelfPermission(
                        baseContext,
                        Manifest.permission.RECORD_AUDIO
                    ) ==
                    PermissionChecker.PERMISSION_GRANTED
                ) {
                    withAudioEnabled()
                }
            }
            .start(ContextCompat.getMainExecutor(this)) { recordEvent ->
                when (recordEvent) {
                    is VideoRecordEvent.Start -> {
                        Toast.makeText(this, "Recording started", Toast.LENGTH_SHORT).show()
                        startRecordingButton.text = getString(R.string.stop_recording)
                    }

                    is VideoRecordEvent.Finalize -> {
                        if (!recordEvent.hasError()) {
                            val msg = "Video capture succeeded: " +
                                    "${recordEvent.outputResults.outputUri}"
                            Toast.makeText(baseContext, msg, Toast.LENGTH_LONG)
                                .show()
                            Log.d("NEW VIDEO", msg)
                            compressVideo(scratchVideoFilePath, videoFilePath)
                        } else {
                            recording?.close()
                            recording = null
                            Log.e(
                                "NEW VIDEO", "Video capture ends with error: " +
                                        "${recordEvent.error}"
                            )
                        }
                        startRecordingButton.apply {
                            text = getString(R.string.start_recording)
                        }
                    }
                }
            }
    }

    private fun compressVideo(scratchVideoFilePath: String, videoFilePath: String) {
        VideoCompress.compressVideoMedium(
            scratchVideoFilePath,
            videoFilePath,
            object : VideoCompress.CompressListener {
                override fun onStart() {
                    runOnUiThread {
                        startRecordingButton.invisible()
                        compressionProgress.visible()
                        compressionProgress.progress = 0
                    }
                }

                override fun onFail() {
                    val inFile = FileInputStream(scratchVideoFilePath)
                    val outFile = FileOutputStream(videoFilePath)
                    inFile.copyTo(outFile)
                    inFile.close()
                    outFile.close()
                    File(scratchVideoFilePath).delete()
                    setResult(RESULT_OK, intent)
                    finish()
                }

                override fun onProgress(p0: Float) {
                    runOnUiThread {
                        compressionProgress.progress = p0.toInt()
                    }
                }

                override fun onSuccess() {
                    File(scratchVideoFilePath).delete()
                    Toast.makeText(applicationContext, "Recording Successful", Toast.LENGTH_SHORT)
                        .show()
                    setResult(RESULT_OK, intent)
                    finish()
                }
            })
    }

//    video_file_path = intent.getStringExtra("video_file_path")!!
//    scratch_video_file_path = "${video_file_path}.scratch.mp4"
//
//    compressionProgress.invisible()
//    compressionProgress.progress = 0

//    innerVideoTextView.text = intent.getStringExtra("sentence")!!
//    innerVideoTextView.movementMethod = ScrollingMovementMethod()

//    cameraView.setLifecycleOwner(this)
//    cameraView.facing = Facing.FRONT
////    cameraView.set() = VideoCodec.H_263
//    cameraView.audio = Audio.ON;
//    cameraView.mode = Mode.VIDEO
//    cameraView.setVideoSize(SizeSelectors.minWidth(360))
//    cameraView.addCameraListener(object : CameraListener() {
//      override fun onVideoTaken(video: VideoResult) {
//        super.onVideoTaken(video)
//
//        VideoCompress.compressVideoMedium(scratch_video_file_path, video_file_path, object: VideoCompress.CompressListener {
//          override fun onStart() = runOnUiThread {
//            stopRecordButton.invisible()
//            compressionProgress.visible()
//            compressionProgress.progress = 0
//          }
//
//          override fun onSuccess() {
//            File(scratch_video_file_path).delete()
////            Toast.makeText(applicationContext, "Recording Successful", Toast.LENGTH_SHORT).show()
////            Log.e("KARYAVID",intent.s)
//            setResult(RESULT_OK, intent)
//            finish()
//          }
//
//          override fun onFail() {
//            val inFile = FileInputStream(scratch_video_file_path)
//            val outFile = FileOutputStream(video_file_path)
//            inFile.copyTo(outFile)
//            inFile.close()
//            outFile.close()
//            File(scratch_video_file_path).delete()
//            setResult(RESULT_OK, intent)
//            finish()
//          }
//
//          override fun onProgress(percent: Float) {
//            runOnUiThread {
//              compressionProgress.progress = percent.toInt()
//            }
//          }
//
//        })
////        stopRecordButton.gone()
//      }
//
////      override fun onVideoRecordingEnd() {
////        super.onVideoRecordingEnd()
////
////      }
//      override fun onCameraError(exception: CameraException) {
//        super.onCameraError(exception)
//        innerVideoTextView.text = cameraView.videoSize.toString() + exception.stackTraceToString()
//
////        Toast.makeText(applicationContext, exception.stackTraceToString(), Toast.LENGTH_LONG).show()
//      }
//
//      override fun onVideoRecordingStart() {
//        super.onVideoRecordingStart()
//        stopRecordButton.text = "Stop Recording"
//        Toast.makeText(applicationContext, "Recording Started", Toast.LENGTH_SHORT).show()
//
//      }
//    })
//    setupCamera()
//    stopRecordButton.visible()
//    stopRecordButton.setOnClickListener {
//      handleStopRecordClick()
//    }
//  }

//  private fun onStartRecording() {
////    cameraView.takePictureSnapshot()
////    cameraView.takeVideo(File(scratch_video_file_path))
//    stopRecordButton.visible()
//  }

//  private fun setupCamera() {
//    onStartRecording()
////    faceBoundsOverlay.setOnStartRecording(::onStartRecording)
//
////    val faceDetector = FaceDetector(faceBoundsOverlay)
////    cameraView.addFrameProcessor {
////      faceDetector.process(
////        Frame(
////          data = it.getData(),
////          rotation = it.rotation,
////          size = Size(it.size.width, it.size.height),
////          format = it.format,
////          lensFacing = LensFacing.FRONT
////        )
////      )
////    }
//  }


}
//  private fun handleStopRecordClick() {
//    if (cameraView.isOpened && !cameraView.isTakingVideo){
//      cameraView.takeVideo(File(scratch_video_file_path))
////      Toast.makeText(applicationContext, "Recording Started", Toast.LENGTH_SHORT).show()
//    }
//    else if (cameraView.isTakingVideo){
//      cameraView.stopVideo()
//      stopRecordButton.text = "Start Recording"
//
////      Toast.makeText(applicationContext, cameraView.videoSize.toString(), Toast.LENGTH_SHORT).show()
////      Toast.makeText(applicationContext, "Recording Stopped", Toast.LENGTH_SHORT).show()
////      stopRecordButton.gone()
//    }
//    else {
//      Toast.makeText(applicationContext, "Not implemented", Toast.LENGTH_SHORT).show()
//    }
//
////    finish()
////    cameraView.takeVideo(File(scratch_video_file_path))
////    Log.e("KARYACAMERA",cameraView.isTakingVideo.toString())
////    cameraView.stopVideo()
//  }

//  override fun onBackPressed() {
//    setResult(500,intent)
//    finish()
//    cameraView.stopVideo()
//  }

//}
