import 'package:flutter/widgets.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_input_widget.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_output_widget.dart';

class SpeechDataWidget extends StatelessWidget {
  final SpeechDataModel speechDataModel;

  const SpeechDataWidget({required this.speechDataModel});

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      Flexible(
          flex: 3,
          child: SpeechDataInputWidget(speechDataInput: speechDataModel.input)),
      Flexible(
          flex: 1,
          child:
              SpeechDataOutputWidget(speechDataOutput: speechDataModel.output))
    ]);
  }
}
