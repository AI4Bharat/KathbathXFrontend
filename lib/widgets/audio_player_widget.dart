import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/enums/audio_player_status.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';

int SAMPLE_RATE = 44100;
int CHANNEL_COUNT = 1;

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;

  const AudioPlayerWidget({super.key, required this.filePath});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool loading = false;
  FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  Duration currentPlayerPosition = Duration.zero;
  Duration totalAudioDuration = Duration.zero;
  StreamSubscription? _streamSubscription;
  AudioPlayerStatus audioPlayerStatus = AudioPlayerStatus.NOT_OPEN;

  Future<void> loadAudioFileDetails(String filePath) async {
    try {
      final audioFile = File(filePath);
      final fileExist = await audioFile.exists();
      if (fileExist) {
        final duration = await getAudioDurationFromFilePath(
            filePath, SAMPLE_RATE, CHANNEL_COUNT, 2);
        setState(() {
          totalAudioDuration =
              Duration(milliseconds: (duration * 1000).toInt());
        });
      }
    } catch (_) {
      updateLoading(false);
      rethrow;
    }
  }

  Future<void> initAudioPlayer() async {
    updateLoading(true);
    print("Init audio player called");
    try {
      final tmpAudioPlayer = await audioPlayer.openPlayer();
      updateAudioPlayerState(AudioPlayerStatus.OPEN);
      audioPlayer = tmpAudioPlayer!;
    } catch (_) {
      updateLoading(false);
      rethrow;
    }

    try {
      await audioPlayer
          .setSubscriptionDuration(const Duration(milliseconds: 100));
      audioPlayer.onProgress!.listen((event) {
        if (audioPlayerStatus == AudioPlayerStatus.PLAYING) {
          updateCurrentPosition(event.position);
        }
      });
    } catch (_) {
      updateLoading(false);
      rethrow;
    }
    updateLoading(false);
  }

  Future<void> startAudioPlayerPlaying() async {
    assert(audioPlayer.isOpen(), "Audio player is not open");
    try {
      await audioPlayer.startPlayer(
          fromURI: widget.filePath,
          sampleRate: SAMPLE_RATE,
          whenFinished: () {
            currentPlayerPosition = totalAudioDuration;
            updateAudioPlayerState(AudioPlayerStatus.STOPPED);
          });
      updateAudioPlayerState(AudioPlayerStatus.PLAYING);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> stopAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPlaying) {
        return true;
      }
      await audioPlayer.stopPlayer();
      updateAudioPlayerState(AudioPlayerStatus.STOPPED);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  Future<bool> pauseAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPlaying) {
        return true;
      }
      await audioPlayer.pausePlayer();
      updateAudioPlayerState(AudioPlayerStatus.PAUSED);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  Future<bool> resumeAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPaused) {
        return true;
      }
      await audioPlayer.resumePlayer();
      updateAudioPlayerState(AudioPlayerStatus.PLAYING);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  void cancelAudioSubscription() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    loadAudioFileDetails(widget.filePath);
  }

  @override
  void dispose() {
    cancelAudioSubscription();
    audioPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return loading ? const CircularProgressIndicator() : _audioPlayer();
  }

  void updateLoading(bool status) {
    setState(() {
      loading = status;
    });
  }

  void updateCurrentPosition(Duration duration) {
    setState(() {
      currentPlayerPosition = duration;
    });
  }

  void updateAudioPlayerState(AudioPlayerStatus status) {
    setState(() {
      audioPlayerStatus = status;
    });
  }

  Future<void> pausePlayerBeforeSeeking() async {
    if (audioPlayer.isStopped) {
      await startAudioPlayerPlaying();
    } else if (audioPlayer.isPaused) {
      await resumeAudioPlayerPlaying();
    }
    await pauseAudioPlayerPlaying();
  }

  Future<void> seekPlayer(Duration duration) async {
    if (!audioPlayer.isOpen()) {
      return;
    }
    if (audioPlayer.isPlaying) {
      await pauseAudioPlayerPlaying();
    }
    updateCurrentPosition(duration);
    await audioPlayer.seekToPlayer(duration);
    assert(
        audioPlayer.isPaused, "The audio player is not paused in seekPlayer()");
    resumeAudioPlayerPlaying();
  }

  void onClick() async {
    try {
      if (audioPlayer.isPlaying) {
        await pauseAudioPlayerPlaying();
      } else if (audioPlayer.isPaused) {
        await resumeAudioPlayerPlaying();
      } else if (audioPlayer.isStopped || audioPlayer.isOpen()) {
        startAudioPlayerPlaying();
      }
    } catch (e) {
      print("Exception occured while playing the audio $e");
      rethrow;
    }
  }

  String getPlayerButtonString() {
    switch (audioPlayerStatus) {
      case AudioPlayerStatus.PLAYING:
        return "Pause";
      case AudioPlayerStatus.PAUSED:
        return "Resume";
      default:
        return "Play";
    }
  }

  Widget _audioPlayer() {
    TextStyle textStyle = const TextStyle(fontSize: 16);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 2,
        children: [
          IconWithTextButton(
              text: getPlayerButtonString(),
              icon: audioPlayerStatus == AudioPlayerStatus.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow,
              backgroundColor: Colors.blue,
              onTap: () => onClick()),
          Expanded(
              child: Column(
            children: [
              Slider(
                value: currentPlayerPosition.inMilliseconds.toDouble(),
                min: 0,
                max: totalAudioDuration.inMilliseconds.toDouble(),
                onChangeStart: (double value) {
                  pausePlayerBeforeSeeking();
                },
                onChanged: (double value) {
                  updateCurrentPosition(Duration(milliseconds: value.toInt()));
                },
                onChangeEnd: (double value) {
                  seekPlayer(Duration(milliseconds: value.toInt()));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      style: textStyle,
                      convertDurationToString(currentPlayerPosition)),
                  Text(
                      style: textStyle,
                      convertDurationToString(totalAudioDuration)),
                ],
              )
            ],
          )),
        ]);
  }
}
