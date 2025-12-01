import 'package:flutter/material.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/enums/audio_player_status.dart';
import 'package:kathbath_lite/enums/audio_recorder_status.dart';
import 'package:kathbath_lite/providers/audio_player_controller.dart';
import 'package:kathbath_lite/providers/audio_recorder_controller.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/widgets/audio_player_widget.dart';
import 'package:kathbath_lite/widgets/audio_recorder_widget.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SpeechDataOutputWidget extends StatefulWidget {
  final SpeechDataOutput speechDataOutput;
  final KaryaDatabase karyaDatabase;

  const SpeechDataOutputWidget(
      {required this.speechDataOutput, required this.karyaDatabase});

  @override
  State<SpeechDataOutputWidget> createState() => _SpeechDataOutputWidget();
}

class _SpeechDataOutputWidget extends State<SpeechDataOutputWidget> {
  late Future<String> outputFilePath;
  // Used to highlight either the recorder or the player
  bool isPlayerActive = true;
  AudioPlayerController audioPlayerController = AudioPlayerController();
  AudioRecorderController audioRecorderController = AudioRecorderController();

  @override
  void initState() {
    super.initState();
    outputFilePath = _setOutputFilePath();
  }

  Future<String> _setOutputFilePath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/${widget.speechDataOutput.outputFileName}';
      return filePath;
    } catch (e) {
      throw const FormatException("Error occured while getting directory path");
    }
  }

  Future<void> updateDatabase(Duration recordingDuration) async {
    try {
      widget.speechDataOutput.updateDuration(recordingDuration);
      await widget.speechDataOutput
          .updatedDatabaseWithOutput(widget.karyaDatabase);
    } catch (e) {
      print("Exception occured $e");
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder<String>(
        future: outputFilePath,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("Failed to initialize the file");
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  audioPlayerRecorder(snapshot.data!),
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                          value: audioPlayerController),
                      ChangeNotifierProvider.value(
                          value: audioRecorderController)
                    ],
                    child: audioPlayerRecorderControl(),
                  ),
                ]);
          }
        });
  }

  Widget audioPlayerRecorder(String filePath) {
    return (isPlayerActive
        ? AudioPlayerWidget(
            filePath: filePath, audioPlayerController: audioPlayerController)
        : AudioRecorderWidget(
            filePath: filePath,
            audioRecorderController: audioRecorderController,
          ));
  }

  Widget audioPlayerRecorderControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 4,
      children: [
        Consumer<AudioRecorderController>(builder: (context, recorder, _) {
          return IconWithTextButton(
              text: getRecorderButtonString(recorder.audidRecorderStatus),
              icon:
                  recorder.audidRecorderStatus == AudioRecorderStatus.RECORDING
                      ? Icons.stop
                      : Icons.record_voice_over_outlined,
              size: isPlayerActive ? 24 : 36,
              backgroundColor: isPlayerActive ? Colors.grey : Colors.red,
              onTap: () => audioRecorderAction());
        }),
        Consumer<AudioPlayerController>(builder: (context, player, _) {
          return IconWithTextButton(
              text: getPlayerButtonString(player.audioPlayerStatus),
              icon: player.audioPlayerStatus == AudioPlayerStatus.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow,
              size: isPlayerActive ? 36 : 24,
              backgroundColor: isPlayerActive ? Colors.blue : Colors.grey,
              onTap: () => audioPlayerAction());
        })
      ],
    );
  }

  void audioRecorderAction() {
    if (audioPlayerController.audioPlayerStatus == AudioPlayerStatus.PLAYING) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Audio is playing"),
        duration: Duration(milliseconds: 300),
      ));
      return;
    }
    setState(() {
      isPlayerActive = false;
    });
    audioRecorderController.action();
  }

  String getRecorderButtonString(AudioRecorderStatus audidRecorderStatus) {
    if (isPlayerActive) {
      return "";
    }
    switch (audidRecorderStatus) {
      case AudioRecorderStatus.RECORDING:
        return "Stop";
      default:
        return "Record";
    }
  }

  void audioPlayerAction() {
    if (audioRecorderController.audidRecorderStatus ==
        AudioRecorderStatus.RECORDING) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Recording in progress"),
        duration: Duration(milliseconds: 300),
      ));
      return;
    }
    setState(() {
      isPlayerActive = true;
    });
    audioPlayerController.action();
  }

  String getPlayerButtonString(AudioPlayerStatus audioPlayerStatus) {
    if (!isPlayerActive) {
      return "";
    }
    switch (audioPlayerStatus) {
      case AudioPlayerStatus.PLAYING:
        return "Pause";
      case AudioPlayerStatus.PAUSED:
        return "Resume";
      default:
        return "Play";
    }
  }
}
