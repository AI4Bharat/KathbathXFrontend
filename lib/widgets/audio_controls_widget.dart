import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_player_model.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:kathbath_lite/widgets/player_widget.dart';
import 'package:kathbath_lite/widgets/recorder_widget.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// ignore: must_be_immutable
class AudioControlsWidget extends StatefulWidget {
  final double progress;
  final String filePath;
  final bool fileExists;
  // final VoidCallback onBackPressed;
  // final VoidCallback onNextPressed;

  const AudioControlsWidget({
    super.key,
    required this.progress,
    // required this.onBackPressed,
    required this.filePath,
    this.fileExists = false,
    // required this.onNextPressed,
  });

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  late final AudioPlayerModel playerModel;
  late final AudioRecorderModel recorderModel;
  bool overWriteConsent = false;

  bool isRecorderPressed = false;

  @override
  void initState() {
    super.initState();
    playerModel = AudioPlayerModel(widget.filePath);
    recorderModel = AudioRecorderModel(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    final recorderPlayerProvider = Provider.of<RecorderPlayerProvider>(context);
    log("Audio bar filepayj: ${widget.filePath}");
    return Column(
      children: [
        PlayerWidget(
          filePath: widget.filePath,
          duration: recorderPlayerProvider.duration,
          playerModel: playerModel,
        ),
        const SizedBox(height: 2),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          // ///////////Back Button/////////////////////
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       WakelockPlus.disable();
          //       recorderPlayerProvider.stopAllRecorders();
          //       recorderPlayerProvider.stopAllPlayers();
          //       recorderPlayerProvider.alreadyPlayed = false;
          //       recorderModel.recordingCentiseconds = 0;
          //       recorderModel.recordingSeconds = 0;
          //       playerModel.duration = 0;
          //       playerModel.resetPlayer();
          //     });
          //
          //     widget.onBackPressed();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.transparent,
          //     shape: const CircleBorder(),
          //     padding: const EdgeInsets.all(5.0),
          //     elevation: 10.0,
          //   ),
          //   child: Image.asset(
          //     'assets/icons/ic_back_enabled.png',
          //     width: 70,
          //     height: 70,
          //   ),
          // ),
          RecorderWidget(
              recorderModel: recorderModel,
              filePath: widget.filePath,
              onRecorderPressed: (newValue) {
                setState(() {
                  isRecorderPressed = newValue;
                });
              }),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       WakelockPlus.disable();
          //       recorderPlayerProvider.stopAllRecorders();
          //       recorderPlayerProvider.stopAllPlayers();
          //       recorderPlayerProvider.alreadyPlayed = false;
          //       recorderModel.recordingCentiseconds = 0;
          //       recorderModel.recordingSeconds = 0;
          //       playerModel.duration = 0;
          //       playerModel.resetPlayer();
          //     });
          //
          //     widget.onNextPressed();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.transparent,
          //     shape: const CircleBorder(),
          //     padding: const EdgeInsets.all(5.0),
          //     elevation: 5.0, // Shadow effect
          //   ),
          //   child: Image.asset(
          //     'assets/icons/ic_next_enabled.png',
          //     width: 70,
          //     height: 70,
          //   ),
          // ),
        ]),
      ],
    );
  }
}
