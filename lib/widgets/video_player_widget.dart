// import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VoidCallback submitAction;
  final String assignmentId;
  final Function(bool) recordingOn;

  const VideoPlayerWidget(
      {super.key,
      required this.submitAction,
      required this.assignmentId,
      required this.recordingOn});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoFilePath = '${directory.path}/${widget.assignmentId}.mp4';
    final videoFile = File(videoFilePath);
    if (!videoFile.existsSync()) {
      debugPrint('Video file does not exist at: $videoFilePath');
      return;
    }
    videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController?.initialize();

    debugPrint('Video Size: ${videoPlayerController!.value.size}');
    debugPrint(
        'Video Aspect Ratio: ${videoPlayerController!.value.aspectRatio}');
    debugPrint(
        'Video Rotation Correction: ${videoPlayerController!.value.rotationCorrection}');

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null ||
        !videoPlayerController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Show loading indicator until initialized
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Chewie(controller: chewieController!),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.submitAction,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Set text color to white
                    ),
                    child: const Text('Done'),
                  ),
                ),
                SizedBox(width: 10), // Optional: add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.recordingOn(
                          true); // Call the function when redo is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Redo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
