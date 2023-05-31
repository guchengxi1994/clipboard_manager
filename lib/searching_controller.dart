import 'package:flutter/material.dart';

class SearchingController extends ChangeNotifier {
  bool show = false;

  static const List<String> options = ["全部", "字符串", "图片", "其它"];
  String currentSelected = "全部";

  changeVisible(bool b) {
    if (show != b) {
      show = b;
      notifyListeners();
    }
  }

  changeCurrentSelected(String s) {
    if (options.contains(s) && currentSelected != s) {
      currentSelected = s;
      notifyListeners();
    }
  }
}
