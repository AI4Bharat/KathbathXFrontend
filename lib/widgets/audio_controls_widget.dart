import 'package:flutter/material.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
// import 'package:kathbath_lite/utils/audio_player_model.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:kathbath_lite/widgets/audio_duration_or_progress_widget.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';
// import 'package:kathbath_lite/widgets/player_widget.dart';
// import 'package:kathbath_lite/widgets/recorder_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AudioControlsWidget extends StatefulWidget {
  // final double progress;
  final String filePath;
  final bool fileExists;
  // final VoidCallback onBackPressed;
  // final VoidCallback onNextPressed;

  const AudioControlsWidget({
    super.key,
    // required this.progress,
    // required this.onBackPressed,
    required this.filePath,
    this.fileExists = false,
    // required this.onNextPressed,
  });

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  // final FlutterSoundRecorder soundRecorder = FlutterSoundRecorder();
  // bool isPlaying = false;
  // bool isRecording = false;
  // late final AudioPlayerModel playerModel;
  late final AudioRecorderModel recorderModel;
  // bool overWriteConsent = false;
  //
  // bool isRecorderPressed = false;
  //

  Future<void> startRecording(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    if (!recorderModel.isRecording) {
      var status = await recorderModel.startRecording();
      if (!status) {
        return;
      }
      recorderModel.soundRecorder!.onProgress!.listen((event) {
				print("The event is $event");
        recorderPlayerInfo.updateTotalDuration(event.duration);
      });
    } else {
      recorderModel.stopRecording();
    }
  }

  @override
  void dispose() {
    recorderModel.closeRecorder();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    recorderModel = AudioRecorderModel(widget.filePath);
    // playerModel = AudioPlayerModel(widget.filePath);
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
              onTap: () => {},
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
    // final recorderPlayerProvider = Provider.of<RecorderPlayerProvider>(context);
    // return Row(
    //   children: [
    //     PlayerWidget(
    //       filePath: widget.filePath,
    //       duration: recorderPlayerProvider.duration,
    //       playerModel: playerModel,
    //     ),
    //     const SizedBox(height: 2),
    //     Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    //       RecorderWidget(
    //           recorderModel: recorderModel,
    //           filePath: widget.filePath,
    //           onRecorderPressed: (newValue) {
    //             setState(() {
    //               isRecorderPressed = newValue;
    //             });
    //           }),
    //     ]),
    //   ],
    // );
  }
}
