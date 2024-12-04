import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/task_api.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, String>> saveAssignmentFiles(
    String microtaskId, String assignmentId,
    {String? imageFilename,
    String? audioFilename,
    String? recordingFilename}) async {
  Dio dio = Dio();
  ApiService apiService = ApiService(dio);
  final MicroTaskAssignmentService microApiService =
      MicroTaskAssignmentService(apiService);
  var tgzFile = await microApiService.getInputFile((assignmentId));
  final GZipDecoder gzipDecoder = GZipDecoder();
  final tarBytes = gzipDecoder.decodeBytes(tgzFile);
  Uint8List? imageBytes;
  Uint8List? audioBytes;
  Uint8List? recordingBytes;
  Map<String, String>? pathMap;
  pathMap ??= {};

  final TarDecoder tarDecoder = TarDecoder();
  tarDecoder.decodeBytes(tarBytes);
  for (final file in tarDecoder.files) {
    if (imageFilename != null && file.filename == imageFilename) {
      imageBytes = file.content as Uint8List;
    }
    if (audioFilename != null && file.filename == audioFilename) {
      audioBytes = file.content as Uint8List;
    }
    if (recordingFilename != null && file.filename == recordingFilename) {
      recordingBytes = file.content as Uint8List;
    }
  }

  final directory = await getApplicationDocumentsDirectory();
  final folderPath = Directory('${directory.path}/$microtaskId');
  if (!(await folderPath.exists())) {
    await folderPath.create(recursive: true);
  }

  if (imageBytes == null && imageFilename != null) {
    throw Exception('File with name $imageFilename not found in the archive.');
  } else if (audioBytes == null && audioFilename != null) {
    throw Exception('File with name $audioFilename not found in the archive.');
  } else if (recordingBytes == null && recordingFilename != null) {
    throw Exception(
        'File with name $recordingFilename not found in the archive.');
  }

  if (imageFilename != null) {
    final imageFilePath = '${directory.path}/$microtaskId/$imageFilename';
    final imageFile = File(imageFilePath);
    await imageFile.writeAsBytes(imageBytes!);
    pathMap['image_path'] = '/$microtaskId/$imageFilename';
  }

  if (audioFilename != null) {
    final audioFilePath = '${directory.path}/$microtaskId/$audioFilename';
    final audioFile = File(audioFilePath);
    await audioFile.writeAsBytes(audioBytes!);
    pathMap['audio_prompt_path'] = '/$microtaskId/$audioFilename';
  }

  if (recordingFilename != null) {
    final recordingFilePath =
        '${directory.path}/$microtaskId/$recordingFilename';
    final recordingFile = File(recordingFilePath);
    await recordingFile.writeAsBytes(recordingBytes!);
    pathMap['recording_path'] = '/$microtaskId/$recordingFilename';
  }
  return pathMap;
}