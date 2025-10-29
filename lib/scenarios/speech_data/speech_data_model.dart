import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';

class SpeechDataModel {
  final SpeechDataInput input;
  final SpeechDataOutput output;

  SpeechDataModel({required this.input, required this.output});

  factory SpeechDataModel.fromRecords(
      MicroTaskAssignment microtaskAssignment, List<Microtask> microtasks) {
    Microtask? currentMicrotask;
    for (Microtask microtask in microtasks) {
      if (microtask.id == microtaskAssignment.microtaskId) {
        currentMicrotask = microtask;
      }
    }
    if (currentMicrotask == null) {
      throw const FormatException(
          "The corresponding microtask for the assignment was not found");
    }
    Map<String, dynamic> microtaskInput = currentMicrotask.input;
    if (!microtaskInput.containsKey("data")) {
      throw const FormatException(
          "The SPEECH_DATA microtask input does not contain data field");
    }
    final Map<String, dynamic> microtaskInputData = microtaskInput["data"]!;
    if (!microtaskInputData.containsKey("sentence")) {
      throw const FormatException(
          "The SPEECH_DATA microtask input does not contain sentence field");
    }

    SpeechDataInput speechDataInput =
        SpeechDataInput(sentence: microtaskInputData["sentence"]! as String);

    SpeechDataOutput speechDataOutput = SpeechDataOutput(
        outputFileName: '${microtaskAssignment.id}.wav',
        outputFileDuration: null);

    return SpeechDataModel(input: speechDataInput, output: speechDataOutput);
  }
}

class SpeechDataInput {
  final String sentence;
  final List<String> hints = const [];

  const SpeechDataInput({required this.sentence});
}

class SpeechDataOutput {
  final String outputFileName;
  final double? outputFileDuration;

  const SpeechDataOutput(
      {required this.outputFileName, required this.outputFileDuration});
}
