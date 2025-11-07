import 'package:flutter_sound/flutter_sound.dart';

Future<FlutterSoundRecorder> initAudioRecorder(FlutterSoundRecorder recorder) async {
  try {
    FlutterSoundRecorder? audioRecorder = await recorder.openRecorder();
    await audioRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 100));
    return audioRecorder;
  } catch (error) {
		throw Exception("Error occured while initializing audio recorder $error");
  }
}

Future<bool> startAudioRecorderRecording(
    FlutterSoundRecorder audioRecorder, String filePath) async {
  try {
    await audioRecorder.startRecorder(
        toFile: filePath, codec: Codec.pcm16WAV, sampleRate: 44100);
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> stopAudioRecorderRecording(FlutterSoundRecorder audioRecorder) async {
  await audioRecorder.stopRecorder();
}
