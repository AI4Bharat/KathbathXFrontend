import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorderModel {
  final String filePath;
  FlutterSoundRecorder? soundRecorder;
  bool isRecording = false;
  String statusText = 'Idle';
  int recordingMinutes = 0;
  int recordingSeconds = 0;
  int recordingCentiseconds = 0;
  double duration = 0;

  AudioRecorderModel(this.filePath) : soundRecorder = FlutterSoundRecorder();

  Future<bool> startRecording() async {
    try {
      if (soundRecorder == null) {
        return false;
      }
      soundRecorder = await soundRecorder!.openRecorder();
      await soundRecorder!
          .setSubscriptionDuration(const Duration(milliseconds: 100));
      await soundRecorder!
          .startRecorder(toFile: filePath, codec: Codec.pcm16WAV);
      isRecording = true;
      return true;
    } catch (_) {
      isRecording = false;
      return false;
    }
  }

  Future<void> stopRecording() async {
    isRecording = false;
    if (soundRecorder == null) {
      return;
    }
    await soundRecorder!.stopRecorder();
  }

  Future<void> closeRecorder() async {
    if (soundRecorder != null) {
      await soundRecorder!.closeRecorder();
    }
  }
}
