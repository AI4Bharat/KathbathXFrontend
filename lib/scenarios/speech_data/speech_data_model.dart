import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';

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
        microtaskAssignmentId: microtaskAssignment.id,
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
  final int microtaskAssignmentId;
  final String outputFileName;
  double? outputFileDuration;

  SpeechDataOutput(
      {required this.microtaskAssignmentId, required this.outputFileDuration})
      : outputFileName = '$microtaskAssignmentId.wav';

  void updateDuration(Duration duration) {
    outputFileDuration = duration.inSeconds.toDouble();
  }

  Future<void> updatedDatabaseWithOutput(KaryaDatabase karyaDatabase) async {
    if (outputFileDuration == null || outputFileDuration! < 0) {
      throw Exception("Duration is not valid");
    }
    MicroTaskAssignmentDao microTaskAssignmentDao =
        karyaDatabase.microTaskAssignmentDao;
    Map<String, dynamic> fileJson = {
      "data": {"duration": outputFileDuration},
      "files": {"recording": outputFileName}
    };
    int rowsAffected = await microTaskAssignmentDao
        .updateMicrotaskAssignmentOutput(microtaskAssignmentId, fileJson);
    if (rowsAffected != 1) {
      throw Exception("Update failed");
    }
    print("the number of rows affected are ${rowsAffected}");
  }
}
