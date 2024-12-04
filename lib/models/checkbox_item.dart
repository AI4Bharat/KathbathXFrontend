import 'package:flutter/foundation.dart';

class CheckboxItem with ChangeNotifier {
  final String text;
  bool _isChecked;

  CheckboxItem({required this.text, bool isChecked = false})
      : _isChecked = isChecked;

  String get itemName => text;
  bool get isChecked => _isChecked;

  void toggle() {
    _isChecked = !_isChecked;
  }
}
