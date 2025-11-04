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
  final Function updateDatabase;

  const AudioControlsWidget({
    super.key,
    required this.filePath,
    required this.updateDatabase,
  });

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  late final AudioPlayerModel playerModel;
  late final AudioRecorderModel recorderModel;
  bool loading = true;

  Future<void> initializePlayerAndRecorder() async {
    recorderModel = AudioRecorderModel(widget.filePath);
    playerModel = AudioPlayerModel(widget.filePath);
    await recorderModel.init();
    await playerModel.init();

    Provider.of<RecorderPlayerInfoProvider>(context, listen: false)
        .updateTotalDuration(playerModel.duration);
    setState(() {
      loading = false;
    });
  }

  Future<void> startRecording(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    if (playerModel.audioPlayer.isPlaying) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Audio is playing"),
          duration: Duration(milliseconds: 300),
        ),
      );
      return;
    }
    if (!recorderModel.audioRecorder.isRecording) {
      var status = await recorderModel.startRecording();
      if (!status) {
        return;
      }
      recorderModel.audioRecorder.onProgress!.listen((event) {
        recorderPlayerInfo.updateTotalDuration(event.duration);
      });
      recorderPlayerInfo.updateIsRecording(true);
      recorderPlayerInfo.updateIsPlaying(false);
    } else {
      await recorderModel.stopRecording();
      playerModel.fileExist = true;
      try {
        await widget.updateDatabase(recorderPlayerInfo.totalDuration);
      } catch (e) {
        print("Error occured while saving the output to assignment table");
      }
      recorderPlayerInfo.updateIsRecording(false);
      recorderPlayerInfo.updateIsPlaying(false);
    }
  }

  Future<void> startPlaying(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    if (recorderModel.audioRecorder.isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Recording in progress"),
          duration: Duration(milliseconds: 300),
        ),
      );
      return;
    }
    await playerModel.startAndStopPlaying(recorderPlayerInfo);
    recorderPlayerInfo.updateIsPlaying(true);
    recorderPlayerInfo.updateIsRecording(false);
  }

  Future<void> seekAudioPlayer(Duration duration) async {
    try {
      RecorderPlayerInfoProvider recorderPlayerInfoProvider =
          Provider.of<RecorderPlayerInfoProvider>(context, listen: false);
      if (!playerModel.audioPlayer.isPlaying &&
          !playerModel.audioPlayer.isPaused) {
        await playerModel.startAndStopPlaying(recorderPlayerInfoProvider);
      }
      recorderPlayerInfoProvider.updateCurrentProgress(duration);
      await playerModel.audioPlayer.seekToPlayer(duration);
      recorderPlayerInfoProvider.updateIsPlaying(true);
      recorderPlayerInfoProvider.updateIsRecording(false);
    } catch (_) {}
  }

  @override
  void dispose() {
		Provider.of<RecorderPlayerInfoProvider>(context, listen: false).resetRecorderPlayerInfo();
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
      return loading
          ? const CircularProgressIndicator()
          : audioControlWidget(recorderPlayerInfo);
    });
  }

  Widget audioControlWidget(RecorderPlayerInfoProvider recorderPlayerInfo) {
    return Column(
      children: [
        AudioDurationOrProgressWidget(
          seekPlayer: seekAudioPlayer,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconWithTextButton(
            text: !playerModel.audioPlayer.isPlaying ? "Play" : "Replay",
            icon: !playerModel.audioPlayer.isPlaying
                ? Icons.play_arrow
                : Icons.stop,
            backgroundColor: Colors.blue,
            onTap: () => startPlaying(recorderPlayerInfo),
          ),
          IconWithTextButton(
            text: !recorderModel.audioRecorder.isRecording ? "Record" : "Stop",
            icon: !recorderModel.audioRecorder.isRecording
                ? Icons.record_voice_over_outlined
                : Icons.stop,
            backgroundColor: Colors.red,
            onTap: () => startRecording(recorderPlayerInfo),
          )
        ]),
      ],
    );
  }
}
