import 'package:clipboard_manager/bridge/native.dart';
import 'package:flutter/material.dart';

class SettingController extends ChangeNotifier {
  bool show = false;
  // String watermark = "xiaoshuyui";
  late String watermark = "";

  init() async {
    watermark = await api.getWatermark();
    notifyListeners();
  }

  changeWatermark(String s) async {
    watermark = s;
    await api.setWatermark(s: s);
    notifyListeners();
  }

  changeVisible(bool b) {
    if (show != b) {
      show = b;
      notifyListeners();
    }
  }
}
