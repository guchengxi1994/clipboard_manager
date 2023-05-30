import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

abstract class BaseModel {
  Future save();
  Future delete();

  String formats;
  int time;
  dynamic content;

  BaseModel({required this.content, required this.formats, required this.time});

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType || other is! BaseModel) {
      return false;
    }

    return other.formats == formats && other.content == content;
  }

  @override
  int get hashCode => formats.hashCode + content.hashCode;
}

class ItemController<T extends BaseModel> extends ChangeNotifier {
  List<T> items = [];
  final FlutterListViewController controller = FlutterListViewController();

  addItem(T t) {
    if (!items.contains(t)) {
      items.add(t);
      notifyListeners();
    }
  }

  removeItem(T t) {
    if (items.contains(t)) {
      items.remove(t);
      notifyListeners();
    }
  }
}
