import 'dart:io';

String convertDurationToString(Duration duration) {
  final hours =
      duration.inHours > 9 ? "${duration.inHours}" : "0${duration.inHours}";
  final minutes = duration.inMinutes > 9
      ? "${duration.inMinutes}"
      : "0${duration.inMinutes}";
  final seconds = duration.inSeconds > 9
      ? "${duration.inSeconds}"
      : "0${duration.inSeconds}";
  return "$hours:$minutes:$seconds";
}

Future<double> getAudioDurationFromFilePath(
    String filePath, int samplingRate, int channelCount, int byteCount) async {
  try {
    final file = File(filePath);
    bool fileExist = await file.exists();
    if (!fileExist) {
      return -1;
    }
    final fileStats = await file.stat();
    final fileDuration =
        (fileStats.size - 44) / (samplingRate * channelCount * byteCount);
    assert(fileDuration <= 0, "File duration is -ve");
    return double.parse(fileDuration.toStringAsFixed(2));
  } catch (_) {
    throw "Error occured while getting file info";
  }
}

Future<bool> checkFileExist(String filePath) async {
  try {
    final file = File(filePath);
    return file.exists();
  } catch (_) {
    return false;
  }
}
