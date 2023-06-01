import 'package:flutter/material.dart';

class SettingController extends ChangeNotifier {
  bool show = false;

  changeVisible(bool b) {
    if (show != b) {
      show = b;
      notifyListeners();
    }
  }
}
