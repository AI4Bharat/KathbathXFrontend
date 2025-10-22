import 'package:flutter/material.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/widgets/audio_controls_widget.dart';
import 'package:kathbath_lite/widgets/display_screen_widget.dart';

class SpeechDataInputWidget extends StatelessWidget {
  final SpeechDataInput speechDataInput;

  const SpeechDataInputWidget({required this.speechDataInput});

  @override
  Widget build(BuildContext buildContext) {
    return Flex(direction: Axis.vertical, children: [
      SentenceDisplayWidget(sentence: speechDataInput.sentence),
      const AudioControlsWidget(
        progress: 40,
        filePath: "",
      )
    ]);
  }
}
