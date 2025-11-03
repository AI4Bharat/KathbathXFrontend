import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorderModel {
  late final FlutterSoundRecorder audioRecorder;
  final String filePath;

  AudioRecorderModel(this.filePath) : audioRecorder = FlutterSoundRecorder();

  Future<bool> init() async {
    try {
      await audioRecorder.openRecorder();
      await audioRecorder
          .setSubscriptionDuration(const Duration(milliseconds: 100));
      return true;
    } catch (error) {
      return true;
    }
  }

  Future<bool> startRecording() async {
    try {
      await audioRecorder.startRecorder(
          toFile: filePath, codec: Codec.pcm16WAV, sampleRate: 44100);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stopRecording() async {
    await audioRecorder.stopRecorder();
  }

  Future<void> closeRecorder() async {
    await audioRecorder.closeRecorder();
  }
}
