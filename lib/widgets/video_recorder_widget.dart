import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoRecorderWidget extends StatefulWidget {
  final String textToRead;
  final String age;
  final String gender;
  final BigInt assignmentId;
  final Function(bool) recordingOn;

  const VideoRecorderWidget(
      {super.key,
      required this.textToRead,
      required this.age,
      required this.gender,
      required this.assignmentId,
      required this.recordingOn});

  @override
  // ignore: library_private_types_in_public_api
  _VideoRecorderWidgetState createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends State<VideoRecorderWidget> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  VideoPlayerController? _videoPlayerController;
  // String? _videoFilePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      await _cameraController
            .lockCaptureOrientation(DeviceOrientation.portraitUp);
        setState(() {});
    } catch (e) {
      log('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_isRecording) {
      await _cameraController
          .lockCaptureOrientation(DeviceOrientation.portraitUp);
      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      final videoFile = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      // log('Video file path: $newFilePath');
      final directory = await getApplicationDocumentsDirectory();
      final videoFilePath = '${directory.path}/${widget.assignmentId}.mp4';
      await File(videoFile.path).copy(videoFilePath);

      // _videoPlayerController = VideoPlayerController.file(file)
      //   ..initialize().then((_) {
      //     setState(() {});
      //     _videoPlayerController?.play();
      //   });

      widget.recordingOn(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Video Recorder'),
      // ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  // child: CameraPreview(_cameraController!),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi), // Mirror preview
                    child: CameraPreview(_cameraController),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: _buildDialogBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _isRecording ? _stopRecording : _startRecording,
                          child: Text(_isRecording
                              ? 'Stop Recording'
                              : 'Start Recording'),
                        ),
                        // ElevatedButton(
                        //   onPressed: widget.submitAction,
                        //   child: const Text('Submit'),
                        // ),
                      ],
                    ), //row
                    // const SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Age: ${widget.age}',
                    //       style: const TextStyle(
                    //           color: Colors.white, fontSize: 16),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     Text(
                    //       'Gender: ${widget.gender}',
                    //       style: const TextStyle(
                    //           color: Colors.white, fontSize: 16),
                    //     ),
                    //   ],
                    // ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.textToRead,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
