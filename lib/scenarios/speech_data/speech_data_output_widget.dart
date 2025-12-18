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
import 'package:kathbath_lite/widgets/dialogs/show_error_dialog.dart';
import 'package:kathbath_lite/widgets/dialogs/skip_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kathbath_lite/widgets/next_n_back_button_widget.dart';
import 'package:provider/provider.dart';

class SpeechDataOutputWidget extends StatefulWidget {
  final SpeechDataOutput speechDataOutput;
  final KaryaDatabase karyaDatabase;
  final PageController pageController;

  const SpeechDataOutputWidget(
      {required this.speechDataOutput,
      required this.karyaDatabase,
      required this.pageController});

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

  Future<void> updateDatabase() async {
    try {
      await widget.speechDataOutput
          .updateDatabaseWithOutput(widget.karyaDatabase);
    } catch (e) {
      showErrorDialog(context, "Exception occured $e");
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
                  NextBackWidget(
                      onBackPressed: previousTask, onNextPressed: nextTask),
                ]);
          }
        });
  }

  Widget audioPlayerRecorder(String filePath) {
    return IndexedStack(index: isPlayerActive ? 0 : 1, children: [
      AudioPlayerWidget(
          filePath: filePath, audioPlayerController: audioPlayerController),
      AudioRecorderWidget(
        filePath: filePath,
        audioRecorderController: audioRecorderController,
      )
    ]);
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
              size: isPlayerActive ? 22 : 36,
              backgroundColor: isPlayerActive ? Colors.grey : Colors.red,
              onTap: () => audioRecorderAction());
        }),
        Consumer<AudioPlayerController>(builder: (context, player, _) {
          return IconWithTextButton(
              text: getPlayerButtonString(player.audioPlayerStatus),
              icon: player.audioPlayerStatus == AudioPlayerStatus.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow,
              size: isPlayerActive ? 36 : 22,
              backgroundColor: isPlayerActive ? Colors.blue : Colors.grey,
              onTap: () => audioPlayerAction());
        })
      ],
    );
  }

  void audioRecorderAction() async {
    if (audioPlayerController.audioPlayerStatus == AudioPlayerStatus.PLAYING) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Audio is playing"),
        duration: Duration(milliseconds: 300),
      ));
      return;
    }

    if (audioRecorderController.audidRecorderStatus ==
        AudioRecorderStatus.RECORDING) {
      updateDatabase();
    }
    await audioPlayerController.resetPlayer();
    audioRecorderController.action();

    setState(() {
      isPlayerActive = false;
    });
  }

  String getRecorderButtonString(AudioRecorderStatus audidRecorderStatus) {
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

    audioPlayerController.action();
    setState(() {
      isPlayerActive = true;
    });
  }

  String getPlayerButtonString(AudioPlayerStatus audioPlayerStatus) {
    switch (audioPlayerStatus) {
      case AudioPlayerStatus.PLAYING:
        return "Pause";
      case AudioPlayerStatus.PAUSED:
        return "Resume";
      default:
        return "Play";
    }
  }

  void nextTask() async {
    if (audioRecorderController.audidRecorderStatus ==
        AudioRecorderStatus.RECORDING) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Recording in progress"),
        duration: Duration(milliseconds: 300),
      ));
      return;
    }

    final isTaskDone =
        await widget.speechDataOutput.isTaskDone(widget.karyaDatabase);
    if (!isTaskDone) {
      final wantToSkip = await showSkipDialog(context);
      if (!wantToSkip) {
        return;
      } else {
        await widget.speechDataOutput.skipTask(
            widget.karyaDatabase); //TODO: Add error message if skipping failed
      }
    }

    widget.pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void previousTask() async {
    if (audioRecorderController.audidRecorderStatus ==
        AudioRecorderStatus.RECORDING) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Recording in progress"),
        duration: Duration(milliseconds: 300),
      ));
      return;
    }

    final isTaskDone =
        await widget.speechDataOutput.isTaskDone(widget.karyaDatabase);
    if (!isTaskDone) {
      final wantToSkip = await showSkipDialog(context);
      if (!wantToSkip) {
        return;
      } else {
        await widget.speechDataOutput.skipTask(
            widget.karyaDatabase); //TODO: Add error message if skipping failed
      }
    }

    widget.pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }
}
