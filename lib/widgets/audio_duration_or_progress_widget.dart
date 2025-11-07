import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_provider.dart';
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
    return SizedBox(
      height: 50,
      child: Consumer<SpeechDataProvider>(
          builder: (context, speechDataProvider, child) {
        if (speechDataProvider.audioRecorder.isRecording ||
            !speechDataProvider.fileExist) {
          return Text(
              style: const TextStyle(fontSize: 32, color: Colors.blueGrey),
              convertDurationToString(speechDataProvider.totalDuration));
        } else if (speechDataProvider.audioPlayer.isPlaying ||
            speechDataProvider.fileExist) {
          return AudioProgressWidget(
            totalDuration: speechDataProvider.totalDuration,
            currentProgress: speechDataProvider.currentDuration,
            onChange: widget.seekPlayer,
          );
        } else {
          return const LinearProgressIndicator();
        }
      }),
    );
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
		print("The current progress is $currentProgress and total duration is $totalDuration");
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
