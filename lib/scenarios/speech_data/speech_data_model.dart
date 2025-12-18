import 'dart:convert';

import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/models/assignment_status_enum.dart';
import 'package:kathbath_lite/scenarios/scenario_base_model.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:path_provider/path_provider.dart';

class SpeechDataModel extends ScenarioBaseModel {
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

    SpeechDataOutput speechDataOutput =
        SpeechDataOutput(microtaskAssignmentId: microtaskAssignment.id);

    return SpeechDataModel(input: speechDataInput, output: speechDataOutput);
  }

  Future<void> initializePermission() async {}

  Future<bool> isTaskDone() async {
    return true;
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

  SpeechDataOutput({required this.microtaskAssignmentId})
      : outputFileName = '$microtaskAssignmentId.wav';

  Future<bool> skipTask(KaryaDatabase karyaDatabase) async {
    try {
      final numberOfRowsUpdated = await karyaDatabase.microTaskAssignmentDao
          .updateMicrotaskAssignmentStatus(BigInt.from(microtaskAssignmentId),
              MicrotaskAssignmentStatus.SKIPPED);
      return numberOfRowsUpdated == 1;
    } catch (_) {
      throw "Error occured while skipping the task";
    }
  }

  Future<bool> isTaskDone(KaryaDatabase karyaDatabase) async {
    try {
      final outputInString = await karyaDatabase.microTaskAssignmentDao
          .getMicrotaskAssignmentOutput(BigInt.from(microtaskAssignmentId));
      if (outputInString == null) {
        return false;
      }
      Map<String, dynamic> outputJson = jsonDecode(outputInString);

      Map<String, dynamic>? outputJsonDataField =
          outputJson['data'] as Map<String, dynamic>?;
      if (outputJsonDataField == null) {
        return false;
      }
      int? duration = outputJsonDataField['duration'] as int?;
      if (duration == null || duration <= 0) {
        return false;
      }

      Map<String, dynamic>? outputJsonFilesField =
          outputJson['files'] as Map<String, dynamic>?;
      if (outputJsonFilesField == null) {
        return false;
      }
      String? fileName = outputJsonFilesField['recording'] as String?;
      if (fileName == null || fileName == "") {
        return false;
      }
      return true;
    } catch (_) {
      throw "Error occured while checking the output of the assignment";
    }
  }

  Future<void> updateDatabaseWithOutput(KaryaDatabase karyaDatabase) async {
    Duration audioFileDuration = Duration.zero;
    final documentPath = await getApplicationDocumentsDirectory();
    final filePath = "${documentPath.path}/$outputFileName";
    try {
      final durationInSecond =
          await getAudioDurationFromFilePath(filePath, 44100, 1, 2);
      if (durationInSecond <= 0) {
        throw "Exception in updateDatabaseWithOutput: the duration of the file returned <= 0 ($durationInSecond)";
        // TODO: Add a dialog box
      }
      audioFileDuration =
          Duration(milliseconds: (durationInSecond * 1000).toInt());
    } catch (e) {
      throw "Exception in updateDatabaseWithOutput: Error occured while getting the audio file duration $e";
    }

    MicroTaskAssignmentDao microTaskAssignmentDao =
        karyaDatabase.microTaskAssignmentDao;
    Map<String, dynamic> fileJson = {
      "data": {"duration": audioFileDuration.inSeconds},
      "files": {"recording": outputFileName}
    };
    try {
      int rowsAffected = await microTaskAssignmentDao
          .updateMicrotaskAssignmentOutput(microtaskAssignmentId, fileJson);
      if (rowsAffected != 1) {
        throw Exception("Update failed");
      }
    } catch (e) {
      throw "Exception in updateDatabaseWithOutput: Error occured while updating the MA table with output file detail $e";
    }
  }
}
