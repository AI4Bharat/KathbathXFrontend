import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/widgets/audio_controls_widget.dart';
import 'package:path_provider/path_provider.dart';

class SpeechDataOutputWidget extends StatefulWidget {
  final SpeechDataOutput speechDataOutput;
  SpeechDataOutputWidget({required this.speechDataOutput});

  @override
  State<SpeechDataOutputWidget> createState() => _SpeechDataOutputWidget();
}

class _SpeechDataOutputWidget extends State<SpeechDataOutputWidget> {
  late Future<String> outputFilePath;

  @override
  void initState() {
    super.initState();
    outputFilePath = _setOutputFilePath();
  }

  Future<String> _setOutputFilePath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/${widget.speechDataOutput.outputFileName}';
    } catch (e) {
      throw const FormatException("Error occured while getting directory path");
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
            return AudioControlsWidget(
              filePath: snapshot.data!,
            );
          }
        });
  }
}
