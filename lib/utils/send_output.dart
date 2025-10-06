// import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/exceptions/file_exceptions.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/task_api.dart';
import 'package:kathbath_lite/utils/navigator_key.dart';
import 'package:kathbath_lite/utils/unauthorized_interceptor.dart';
import 'package:kathbath_lite/utils/wav2tgz_convert.dart';
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
    await convertWavToTgz(filePath, outputTgzFilePath, assignmentId);
    String checksum = await calculateMd5Checksum(outputTgzFilePath);

    final jsonString =
        '{\n    "container_name": "microtask-assignment-output",\n    "name": "$assignmentId.tgz",\n    "algorithm": "MD5",\n    "checksum": "$checksum"\n}';
//////////To update server db////////////////
    dio = Dio();
    dio.interceptors.add(TokenInterceptor(navigatorKey));
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

Future<UploadResult> sendOutputFileWithInput(
    String assignmentId, MicroTaskAssignmentRecord mARecord) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$assignmentId.wav';
  final inputFolderPath = '${directory.path}/${mARecord.microtaskId}';
  String outputTgzFilePath = p.setExtension(filePath, '.tgz');

  log("Recieved filepath: $filePath and microtaskId is: ${mARecord.microtaskId} and output file is: $outputTgzFilePath");
  late Dio dio;
  late ApiService apiService;

  final inputFolder = Directory(inputFolderPath);
  try {
    if (await inputFolder.exists()) {
      await convertAllToTgz(
          inputFolderPath, filePath, outputTgzFilePath, assignmentId);
    } else {
      await convertWavToTgz(filePath, outputTgzFilePath, assignmentId);
    }
    String checksum = await calculateMd5Checksum(outputTgzFilePath);

    final jsonString =
        '{\n    "container_name": "microtask-assignment-output",\n    "name": "$assignmentId.tgz",\n    "algorithm": "MD5",\n    "checksum": "$checksum"\n}';
//////////To update server db////////////////
    dio = Dio();
    dio.interceptors.add(TokenInterceptor(navigatorKey));
    apiService = ApiService(dio);
    final MicroTaskAssignmentService microApiService =
        MicroTaskAssignmentService(apiService);
    var response = await microApiService.submitAssignmentOutputFile(
        assignmentId, jsonString, outputTgzFilePath);
    String outputFileId = response.data?['id'];
    return UploadResult(fileId: outputFileId);
  } catch (e, stack) {
    log('Error: $e');
    FirebaseCrashlytics.instance
        .log("sendOutputFileWithInput failed for assignmentId: $assignmentId");
    await FirebaseCrashlytics.instance.recordError(
      e,
      stack,
      reason: "Error in sendOutputFileWithInput",
      fatal: false,
    );
    if (e is DioException) {
      return UploadResult(
          errorType: "networkError", errorMsg: "Please check the network");
    } else if (e is WavFileNotFoundException) {
      return UploadResult(errorType: "fileNotFound", errorMsg: e.toString());
    }
    // showDialog(
    //   context: navigatorKey.currentContext!,
    //   builder: (ctx) => AlertDialog(
    //     title: const Text("Upload Failed"),
    //     content: Text("An error occurred: $e"),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(ctx).pop(),
    //         child: const Text("OK"),
    //       ),
    //     ],
    //   ),
    // );
    return UploadResult(errorMsg: e.toString());
  }
}

Future<String> calculateMd5Checksum(String filePath) async {
  final file = File(filePath);
  final fileBytes = await file.readAsBytes();
  final digest = md5.convert(fileBytes);
  return digest.toString();
}

class UploadResult {
  final String? fileId; // success value
  final String? errorType;
  final String? errorMsg; // error message

  UploadResult({this.fileId, this.errorType, this.errorMsg});
}
