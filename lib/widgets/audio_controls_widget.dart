import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_provider.dart';
import 'package:kathbath_lite/utils/audio_player_model.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:kathbath_lite/widgets/audio_duration_or_progress_widget.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';
import 'package:provider/provider.dart';

class AudioControlsWidget extends StatefulWidget {
  final String filePath;

  const AudioControlsWidget({
    super.key,
    required this.filePath,
  });

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  // late final AudioPlayerModel playerModel;
  // late final AudioRecorderModel recorderModel;
  //
  // Future<void> initializePlayerAndRecorder() async {
  //   recorderModel = AudioRecorderModel(widget.filePath);
  //   playerModel = AudioPlayerModel(widget.filePath);
  //   await recorderModel.init();
  //   await playerModel.init();
  //
  //   Provider.of<RecorderPlayerInfoProvider>(context, listen: false)
  //       .updateTotalDuration(playerModel.duration);
  //   setState(() {
  //     loading = false;
  //   });
  // }

  Future<void> startRecording(SpeechDataProvider speechDataProvider) async {
    if (speechDataProvider.audioPlayer.isPlaying) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Audio is playing"),
          duration: Duration(milliseconds: 300),
        ),
      );
      return;
    }
    if (!speechDataProvider.audioRecorder.isRecording) {
      var status = await speechDataProvider.startRecording();
      if (!status) {
        return;
      }
    } else {
      await speechDataProvider.stopRecording();
      // try {
      //   // await widget.updateDatabase(recorderPlayerInfo.totalDuration);
      // } catch (e) {
      //   print("Error occured while saving the output to assignment table");
      // }
    }
  }

  Future<void> startPlaying(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    // if (recorderModel.audioRecorder.isRecording) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Recording in progress"),
    //       duration: Duration(milliseconds: 300),
    //     ),
    //   );
    //   return;
    // }
    // await playerModel.startAndStopPlaying(recorderPlayerInfo);
    // recorderPlayerInfo.updateIsPlaying(true);
    // recorderPlayerInfo.updateIsRecording(false);
  }

  Future<void> seekAudioPlayer(Duration duration) async {
    // try {
    //   RecorderPlayerInfoProvider recorderPlayerInfoProvider =
    //       Provider.of<RecorderPlayerInfoProvider>(context, listen: false);
    //   if (!playerModel.audioPlayer.isPlaying &&
    //       !playerModel.audioPlayer.isPaused) {
    //     await playerModel.startAndStopPlaying(recorderPlayerInfoProvider);
    //   }
    //   recorderPlayerInfoProvider.updateCurrentProgress(duration);
    //   await playerModel.audioPlayer.seekToPlayer(duration);
    //   recorderPlayerInfoProvider.updateIsPlaying(true);
    //   recorderPlayerInfoProvider.updateIsRecording(false);
    // } catch (_) {}
  }

  @override
  void dispose() {
    // Provider.of<RecorderPlayerInfoProvider>(context, listen: false)
    //     .resetRecorderPlayerInfo();
    // recorderModel.closeRecorder();
    // playerModel.closeAudioPlayer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initializePlayerAndRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechDataProvider>(
        builder: (context, speechDataProvider, child) {
      return speechDataProvider.loading
          ? const CircularProgressIndicator()
          : audioControlWidget(speechDataProvider);
    });
  }

  Widget audioControlWidget(SpeechDataProvider speechDataProvider) {
    return Column(
      children: [
        AudioDurationOrProgressWidget(
          seekPlayer: seekAudioPlayer,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          // IconWithTextButton(
          //   text: !playerModel.audioPlayer.isPlaying
          //       ? "Play"
          //       : "Replay",
          //   icon: !playerModel.audioPlayer.isPlaying
          //       ? Icons.play_arrow
          //       : Icons.stop,
          //   backgroundColor: Colors.blue,
          //   onTap: () => startPlaying(recorderPlayerInfo),
          // ),
          IconWithTextButton(
            text: speechDataProvider.audioRecorder.isRecording
                ? "Stop"
                : "Record",
            icon: speechDataProvider.audioRecorder.isRecording
                ? Icons.stop
                : Icons.record_voice_over_outlined,
            backgroundColor: Colors.red,
            onTap: () => startRecording(speechDataProvider),
          )
        ]),
      ],
    );
  }
}
