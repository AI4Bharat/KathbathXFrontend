import 'dart:io';
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
