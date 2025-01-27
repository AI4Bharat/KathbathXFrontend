// import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
// import 'package:karya_flutter/data/database/utility/table_utility.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/task_api.dart';
import 'package:karya_flutter/utils/wav2tgz_convert.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String?> sendOutputFile(
    String assignmentId, MicroTaskAssignmentRecord mARecord) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$assignmentId.wav';
  String outputTgzFilePath = p.setExtension(filePath, '.tgz');

  log("Recieved filepath: $filePath");
  late Dio dio;
  late ApiService apiService;

  try {
    await convertWavToTgz(filePath, outputTgzFilePath);
    String checksum = await calculateMd5Checksum(outputTgzFilePath);

    final jsonString =
        '{\n    "container_name": "microtask-assignment-output",\n    "name": "$assignmentId.tgz",\n    "algorithm": "MD5",\n    "checksum": "$checksum"\n}';
//////////To update server db////////////////
    dio = Dio();
    apiService = ApiService(dio);
    final MicroTaskAssignmentService microApiService =
        MicroTaskAssignmentService(apiService);
    var jsonOut = await microApiService.submitAssignmentOutputFile(
        assignmentId, jsonString, outputTgzFilePath);
    String outputFileId = jsonOut.data?['id'];
    return outputFileId;
  } catch (e) {
    log('Error: $e');
  }
  return null;
}

Future<String?> sendOutputFileWithInput(
    String assignmentId, MicroTaskAssignmentRecord mARecord) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$assignmentId.wav';
  // final extDir = await getExternalStorageDirectory();
  // final tgzFilePath = '${extDir!.path}/$assignmentId.wav';
  final inputFolderPath = '${directory.path}/${mARecord.microtaskId}';
  String outputTgzFilePath = p.setExtension(filePath, '.tgz');

  log("Recieved filepath: $filePath and microtaskId is: ${mARecord.microtaskId} and output file is: $outputTgzFilePath");
  late Dio dio;
  late ApiService apiService;

  final inputFolder = Directory(inputFolderPath);
  try {
    if (await inputFolder.exists()) {
      await convertAllToTgz(inputFolderPath, filePath, outputTgzFilePath);
    } else {
      await convertWavToTgz(filePath, outputTgzFilePath);
    }
    String checksum = await calculateMd5Checksum(outputTgzFilePath);

    final jsonString =
        '{\n    "container_name": "microtask-assignment-output",\n    "name": "$assignmentId.tgz",\n    "algorithm": "MD5",\n    "checksum": "$checksum"\n}';
//////////To update server db////////////////
    dio = Dio();
    apiService = ApiService(dio);
    final MicroTaskAssignmentService microApiService =
        MicroTaskAssignmentService(apiService);
    var jsonOut = await microApiService.submitAssignmentOutputFile(
        assignmentId, jsonString, outputTgzFilePath);
    String outputFileId = jsonOut.data?['id'];
    return outputFileId;
  } catch (e) {
    log('Error: $e');
  }
  return null;
}

Future<String> calculateMd5Checksum(String filePath) async {
  final file = File(filePath);
  final fileBytes = await file.readAsBytes();
  final digest = md5.convert(fileBytes);
  return digest.toString();
}
