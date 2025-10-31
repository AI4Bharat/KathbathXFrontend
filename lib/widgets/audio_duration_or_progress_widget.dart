import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:provider/provider.dart';

class AudioDurationOrProgressWidget extends StatefulWidget {
  AudioDurationOrProgressWidget();

  @override
  State<AudioDurationOrProgressWidget> createState() =>
      _AudioDurationOrProgressWidget();
}

class _AudioDurationOrProgressWidget
    extends State<AudioDurationOrProgressWidget> {
  @override
  Widget build(BuildContext buildContext) {
    return Consumer<RecorderPlayerInfoProvider>(
        builder: (context, recorderPlayerInfo, child) {
      if (recorderPlayerInfo.isRecording) {
        return Text(
            style: const TextStyle(fontSize: 32, color: Colors.blueGrey),
            recorderPlayerInfo.totalDurationInString);
      } else if (recorderPlayerInfo.isPlaying || recorderPlayerInfo.fileExist) {
        return AudioProgressWidget(
            totalDuration: recorderPlayerInfo.totalDuration,
            currentProgress: recorderPlayerInfo.currentProgress);
      } else {
        return Text(
            "isRecording ${recorderPlayerInfo.isRecording} isPlaying ${recorderPlayerInfo.isPlaying} fileExist ${recorderPlayerInfo.fileExist}");
      }
    });
  }
}

class AudioProgressWidget extends StatelessWidget {
  Duration totalDuration;
  Duration currentProgress;

  AudioProgressWidget(
      {required this.totalDuration, required this.currentProgress});

  @override
  Widget build(BuildContext buildContext) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(convertDurationToString(currentProgress)),
      Expanded(
        child: LinearProgressIndicator(
          value: currentProgress.inSeconds / totalDuration.inSeconds,
        ),
      ),
      Text(convertDurationToString(totalDuration))
    ]);
  }
}
