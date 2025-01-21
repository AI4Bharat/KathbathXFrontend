import 'dart:io';
import 'dart:developer';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

Future<void> convertWavToTgz(
    String wavFilePath, String outputTgzFilePath) async {
  final wavFile = File(wavFilePath);
  if (!await wavFile.exists()) {
    throw Exception('WAV file does not exist');
  }

  final wavFileName = p.basename(wavFilePath);
  final wavFileBytes = await wavFile.readAsBytes();
  final archive = Archive();
  archive.addFile(ArchiveFile(wavFileName, wavFileBytes.length, wavFileBytes));
  final tarEncoder = TarEncoder();
  final tarBytes = tarEncoder.encode(archive);
  final gzippedBytes = GZipEncoder().encode(tarBytes);
  final outputFile = File(outputTgzFilePath);
  await outputFile.writeAsBytes(gzippedBytes!);

  print('Converted $wavFilePath to $outputTgzFilePath');
}

Future<void> convertAllToTgz(
    String folderPath, String wavFilePath, String outputTgzFilePath) async {
  final wavFile = File(wavFilePath);
  if (!await wavFile.exists()) {
    throw Exception('WAV file does not exist');
  }
  final inputFolder = Directory(folderPath);
  if (!await inputFolder.exists()) {
    throw Exception('Folder does not exist');
  }
  final archive = Archive();

  //moving all the input filea to the archive object
  await for (var file
      in inputFolder.list(recursive: true, followLinks: false)) {
    if (file is File) {
      final filePath = file.path;
      final fileName = p.relative(filePath, from: folderPath);
      final fileBytes = await file.readAsBytes();
      archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
    }
  }

  //moving output file in the archive
  final wavFileName = p.basename(wavFilePath);
  final wavFileBytes = await wavFile.readAsBytes();
  archive.addFile(ArchiveFile(wavFileName, wavFileBytes.length, wavFileBytes));

  final tarEncoder = TarEncoder();
  final tarBytes = tarEncoder.encode(archive);
  final gzippedBytes = GZipEncoder().encode(tarBytes);
  final outputFile = File(outputTgzFilePath);
  await outputFile.writeAsBytes(gzippedBytes!);

  log('Converted $wavFilePath to $outputTgzFilePath');
}
