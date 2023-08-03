import 'package:flutter/material.dart';

class LiquidButtonProvider extends ChangeNotifier {
  bool _isOn = false;
  bool get isOn => _isOn;

  void toggle() {
    _isOn = !_isOn;
    notifyListeners();
  }
}
