import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:provider/provider.dart';

class AudioDurationOrProgressWidget extends StatefulWidget {
  @override
  State<AudioDurationOrProgressWidget> createState() =>
      _AudioDurationOrProgressWidget();
}

class _AudioDurationOrProgressWidget
    extends State<AudioDurationOrProgressWidget> {
  bool showDuration = true;

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<RecorderPlayerInfoProvider>(
        builder: (context, recorderPlayerInfo, child) {
      return Text(
          style: const TextStyle(fontSize: 32, color: Colors.blueGrey),
          recorderPlayerInfo.totalDurationInString);
    });
  }
}
