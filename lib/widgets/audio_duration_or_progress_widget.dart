import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:provider/provider.dart';

class AudioDurationOrProgressWidget extends StatefulWidget {
  Function seekPlayer;
  AudioDurationOrProgressWidget({required this.seekPlayer});

  @override
  State<AudioDurationOrProgressWidget> createState() =>
      _AudioDurationOrProgressWidget();
}

class _AudioDurationOrProgressWidget
    extends State<AudioDurationOrProgressWidget> {
  @override
  Widget build(BuildContext buildContext) {
    return SizedBox(height: 50,child: Consumer<RecorderPlayerInfoProvider>(
        builder: (context, recorderPlayerInfo, child) {
      if (recorderPlayerInfo.isRecording || !recorderPlayerInfo.fileExist) {
        return Text(
            style: const TextStyle(fontSize: 32, color: Colors.blueGrey),
            recorderPlayerInfo.totalDurationInString);
      } else if (recorderPlayerInfo.isPlaying || recorderPlayerInfo.fileExist) {
        return AudioProgressWidget(
          totalDuration: recorderPlayerInfo.totalDuration,
          currentProgress: recorderPlayerInfo.currentProgress,
          onChange: widget.seekPlayer,
        );
      } else {
        return const LinearProgressIndicator();
      }
    }));
  }
}

class AudioProgressWidget extends StatelessWidget {
  Duration totalDuration;
  Duration currentProgress;
  Function onChange;
  static TextStyle textStyle = const TextStyle(fontSize: 16);

  AudioProgressWidget(
      {required this.totalDuration,
      required this.currentProgress,
      required this.onChange});

  @override
  Widget build(BuildContext buildContext) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 2,
        children: [
          Text(style: textStyle, convertDurationToString(currentProgress)),
          Expanded(
            child: Slider(
              value: currentProgress.inMilliseconds.toDouble(),
              min: 0,
              max: totalDuration.inMilliseconds.toDouble(),
              onChanged: (double value) => {
                onChange(Duration(milliseconds: value.toInt())),
              },
            ),
          ),
          Text(style: textStyle, convertDurationToString(totalDuration))
        ]);
  }
}
