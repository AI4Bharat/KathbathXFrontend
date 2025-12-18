import 'package:flutter/widgets.dart';

class SpeechDataProvider extends ChangeNotifier {
  Duration _totalDuration = Duration.zero;

  get totalDuration => _totalDuration;

  void updateTotalDuration(Duration duration) {
    _totalDuration = duration;
    notifyListeners();
  }
}
