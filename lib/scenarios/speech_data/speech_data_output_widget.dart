import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:kathbath_lite/widgets/audio_controls_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SpeechDataOutputWidget extends StatefulWidget {
  final SpeechDataOutput speechDataOutput;
  SpeechDataOutputWidget({required this.speechDataOutput});

  @override
  State<SpeechDataOutputWidget> createState() => _SpeechDataOutputWidget();
}

class _SpeechDataOutputWidget extends State<SpeechDataOutputWidget> {
  late Future<String> outputFilePath;
  late bool outputFileExist;

  @override
  void initState() {
    super.initState();
    outputFilePath = _setOutputFilePath();
  }

  Future<String> _setOutputFilePath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print("The output path is ${directory.path}\n\n");
      final filePath =
          '${directory.path}/${widget.speechDataOutput.outputFileName}';
      final fileExist = await checkFileExist(filePath);
      setState(() {
        outputFileExist = fileExist;
      });
      return filePath;
    } catch (e) {
      print("Error occured while getting application path ${e} \n\n");
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
              outputFileExist: outputFileExist,
            );
          }
        });
  }
}
