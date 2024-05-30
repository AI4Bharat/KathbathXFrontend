package com.ai4bharat.karya.ui.scenarios.signVideo

import android.media.CamcorderProfile
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.util.Size
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.ai4bharat.karya.R
//import com.ai4bharat.karya.ui.scenarios.signVideo.facedetector.FaceDetector
//import com.ai4bharat.karya.ui.scenarios.signVideo.facedetector.Frame
//import com.ai4bharat.karya.ui.scenarios.signVideo.facedetector.LensFacing
import com.ai4bharat.karya.utils.extensions.gone
import com.ai4bharat.karya.utils.extensions.invisible
import com.ai4bharat.karya.utils.extensions.visible
import com.otaliastudios.cameraview.*
import com.otaliastudios.cameraview.controls.*
import com.otaliastudios.cameraview.size.SizeSelectors
import com.vincent.videocompressor.VideoCompress
import kotlinx.android.synthetic.main.fragment_sign_video_record.*
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class SignVideoRecord : AppCompatActivity() {

  private lateinit var video_file_path: String
  private lateinit var scratch_video_file_path: String

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.fragment_sign_video_record)

    video_file_path = intent.getStringExtra("video_file_path")!!
    scratch_video_file_path = "${video_file_path}.scratch.mp4"

    compressionProgress.invisible()
    compressionProgress.progress = 0

    innerVideoTextView.text = intent.getStringExtra("sentence")!!
    innerVideoTextView.movementMethod = ScrollingMovementMethod()

    cameraView.setLifecycleOwner(this)
    cameraView.facing = Facing.FRONT
//    cameraView.set() = VideoCodec.H_263
    cameraView.audio = Audio.ON;
    cameraView.mode = Mode.VIDEO
    cameraView.setVideoSize(SizeSelectors.minWidth(360))
    cameraView.addCameraListener(object : CameraListener() {
      override fun onVideoTaken(video: VideoResult) {
        super.onVideoTaken(video)

        VideoCompress.compressVideoMedium(scratch_video_file_path, video_file_path, object: VideoCompress.CompressListener {
          override fun onStart() = runOnUiThread {
            stopRecordButton.invisible()
            compressionProgress.visible()
            compressionProgress.progress = 0
          }

          override fun onSuccess() {
            File(scratch_video_file_path).delete()
//            Toast.makeText(applicationContext, "Recording Successful", Toast.LENGTH_SHORT).show()
//            Log.e("KARYAVID",intent.s)
            setResult(RESULT_OK, intent)
            finish()
          }

          override fun onFail() {
            val inFile = FileInputStream(scratch_video_file_path)
            val outFile = FileOutputStream(video_file_path)
            inFile.copyTo(outFile)
            inFile.close()
            outFile.close()
            File(scratch_video_file_path).delete()
            setResult(RESULT_OK, intent)
            finish()
          }

          override fun onProgress(percent: Float) {
            runOnUiThread {
              compressionProgress.progress = percent.toInt()
            }
          }

        })
//        stopRecordButton.gone()
      }

//      override fun onVideoRecordingEnd() {
//        super.onVideoRecordingEnd()
//
//      }
      override fun onCameraError(exception: CameraException) {
        super.onCameraError(exception)
        innerVideoTextView.text = cameraView.videoSize.toString() + exception.stackTraceToString()

//        Toast.makeText(applicationContext, exception.stackTraceToString(), Toast.LENGTH_LONG).show()
      }

      override fun onVideoRecordingStart() {
        super.onVideoRecordingStart()
        stopRecordButton.text = "Stop Recording"
        Toast.makeText(applicationContext, "Recording Started", Toast.LENGTH_SHORT).show()

      }
    })
//    setupCamera()
    stopRecordButton.visible()
    stopRecordButton.setOnClickListener {
      handleStopRecordClick()
    }
  }

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

  private fun handleStopRecordClick() {
    if (cameraView.isOpened && !cameraView.isTakingVideo){
      cameraView.takeVideo(File(scratch_video_file_path))
//      Toast.makeText(applicationContext, "Recording Started", Toast.LENGTH_SHORT).show()
    }
    else if (cameraView.isTakingVideo){
      cameraView.stopVideo()
      stopRecordButton.text = "Start Recording"

//      Toast.makeText(applicationContext, cameraView.videoSize.toString(), Toast.LENGTH_SHORT).show()
//      Toast.makeText(applicationContext, "Recording Stopped", Toast.LENGTH_SHORT).show()
//      stopRecordButton.gone()
    }
    else {
      Toast.makeText(applicationContext, "Not implemented", Toast.LENGTH_SHORT).show()
    }

//    finish()
//    cameraView.takeVideo(File(scratch_video_file_path))
//    Log.e("KARYACAMERA",cameraView.isTakingVideo.toString())
//    cameraView.stopVideo()
  }

  override fun onBackPressed() {
//    setResult(500,intent)
//    finish()
//    cameraView.stopVideo()
  }

}
