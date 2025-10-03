import 'package:flutter/foundation.dart';
import 'package:kathbath_lite/models/checkbox_item.dart';

class CheckboxProvider with ChangeNotifier {
  final List<CheckboxItem> _items;

  CheckboxProvider(List<String> texts)
      : _items = texts.map((text) => CheckboxItem(text: text)).toList();

  List<CheckboxItem> get items => _items;

  void toggleItem(int index) {
    _items[index].toggle();
    // log(
    //     "item at ${_items[index].itemName} is checked? : ${_items[index].isChecked}");
    notifyListeners();
  }

  void resetAll() {
    for (var item in _items) {
      if (item.isChecked == true) {
        item.toggle();
      }
      notifyListeners(); // Notify listeners about the changes
    }
  }
}
