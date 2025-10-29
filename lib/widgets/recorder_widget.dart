import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// ignore: must_be_immutable
class RecorderWidget extends StatelessWidget {
  final String filePath;
  final AudioRecorderModel recorderModel;
  final Function(bool) onRecorderPressed;
  bool overWriteConsent = false;

  RecorderWidget(
      {super.key,
      required this.filePath,
      required this.recorderModel,
      required this.onRecorderPressed,
      this.overWriteConsent = false});

//To handle Record button presses
  onRecordPressed(
      BuildContext context, RecorderPlayerInfoProvider rPProvider) async {
    // if (recorderModel.isRecording) {
    //   WakelockPlus.disable();
    //   rPProvider.stopRecording(recorderModel);
    //   onRecorderPressed(true);
    //   overWriteConsent = false;
    // } else {
    //   final directory = await getApplicationDocumentsDirectory();
    //   String recorderFilePath = '${directory.path}$filePath';
    //   final file = File(recorderFilePath);
    //   bool fileExists = await file.exists();
    //   rPProvider.stopAllPlayers();
    //   if (!overWriteConsent && fileExists) {
    //     bool? consent = await _showOverwriteDialog(context);
    //     if (consent == true) {
    //       overWriteConsent = true;
    //       recorderModel.recordingCentiseconds = 0;
    //       recorderModel.recordingSeconds = 0;
    //       WakelockPlus.enable();
    //       rPProvider.startRecording(context, recorderModel, filePath);
    //     }
    //   } else {
    //     WakelockPlus.enable();
    //     rPProvider.startRecording(context, recorderModel, filePath);
    //   }
    // }
  }

  // Future<bool?> _showOverwriteDialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Overwrite Recording'),
  //         content: const Text(
  //             'A previous recording exists. You wish to overwrite the current recording?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //               overWriteConsent = false;
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(true);
  //               overWriteConsent = true;
  //             },
  //             child: const Text("Overwrite"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecorderPlayerInfoProvider>(
        builder: (context, recorderPlayerProvider, child) {
      return Column(children: [
        ////////////////////////////////////Recording Time/////////////////////////////////////
        Container(
            padding: const EdgeInsets.all(0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "${recorderModel.recordingMinutes}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                ".${recorderModel.recordingSeconds.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () => onRecordPressed(context, recorderPlayerProvider),
                child: const Icon(
                  color: Colors.orange,
                  Icons.record_voice_over_rounded,
                ),
              )
            ]))
      ]);
    });
  }
}
