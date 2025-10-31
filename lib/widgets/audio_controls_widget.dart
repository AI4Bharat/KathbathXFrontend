import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_player_model.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:kathbath_lite/widgets/audio_duration_or_progress_widget.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';
import 'package:provider/provider.dart';

class AudioControlsWidget extends StatefulWidget {
  final String filePath;
  final bool outputFileExist;

  const AudioControlsWidget({
    super.key,
    required this.filePath,
    required this.outputFileExist,
  });

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  late final AudioPlayerModel playerModel;
  late final AudioRecorderModel recorderModel;
  // StreamSubscription? playerSubscription;

  Future<void> initializePlayerAndRecorder() async {
    recorderModel = AudioRecorderModel(widget.filePath);
    playerModel = AudioPlayerModel(widget.filePath);
    await recorderModel.init();
    await playerModel.init();

    Provider.of<RecorderPlayerInfoProvider>(context, listen: false)
        .updateTotalDuration(playerModel.duration);
  }

  Future<void> startRecording(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    if (!recorderModel.isRecording) {
      var status = await recorderModel.startRecording();
      if (!status) {
        return;
      }
      recorderModel.soundRecorder!.onProgress!.listen((event) {
        print("The event is ${event}");
        recorderPlayerInfo.updateTotalDuration(event.duration);
      });
      recorderPlayerInfo.updateIsRecording(true);
      recorderPlayerInfo.updateIsPlaying(false);
    } else {
      await recorderModel.stopRecording();
      recorderPlayerInfo.updateIsRecording(false);
      recorderPlayerInfo.updateIsPlaying(false);
    }
  }

  @override
  void dispose() {
    recorderModel.closeRecorder();
    playerModel.closeAudioPlayer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializePlayerAndRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecorderPlayerInfoProvider>(
        builder: (context, recorderPlayerInfo, child) {
      return Column(
        children: [
          AudioDurationOrProgressWidget(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconWithTextButton(
              text: "Play",
              icon: Icons.play_arrow,
              backgroundColor: Colors.blue,
              onTap: () => playerModel.startAndStopPlaying(recorderPlayerInfo),
            ),
            IconWithTextButton(
              text: "Record",
              icon: Icons.record_voice_over_outlined,
              backgroundColor: Colors.red,
              onTap: () => startRecording(recorderPlayerInfo),
            )
          ]),
        ],
      );
    });
  }
}
