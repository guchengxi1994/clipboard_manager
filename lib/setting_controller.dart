import 'package:flutter/material.dart';

class SettingController extends ChangeNotifier {
  bool show = false;
  String watermark = "xiaoshuyui";

  changeWatermark(String s) {
    watermark = s;
    notifyListeners();
  }

  changeVisible(bool b) {
    if (show != b) {
      show = b;
      notifyListeners();
    }
  }
}
