import 'package:flutter/widgets.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_input_widget.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';

class SpeechDataWidget extends StatelessWidget {
  final SpeechDataModel speechDataModel;

  const SpeechDataWidget({required this.speechDataModel});

  @override
  Widget build(BuildContext context) {
    return SpeechDataInputWidget(speechDataInput: speechDataModel.input);
  }
}
