import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

abstract class BaseModel {
  Future save();
  Future delete();

  String formats;
  int time;
  dynamic content;
  Map<String, String> metadata;

  BaseModel(
      {required this.content,
      required this.formats,
      required this.time,
      this.metadata = const {}});

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
  List<T> filtered = [];

  addItem(T t) {
    if (!items.contains(t)) {
      items.insert(0, t);
      notifyListeners();
    }
  }

  removeItem(T t) {
    if (items.contains(t)) {
      items.remove(t);
      notifyListeners();
    }
  }

  clearFiltered() {
    isFiltered = false;
    notifyListeners();
  }

  bool isFiltered = false;

  getFiltered({String? type, int? startTime, int? endTime}) {
    assert(type != null || (startTime != null && endTime != null));
    if (type != null) {
      // filtered = items.where((element) => element.formats == type).toList();
      switch (type) {
        case "全部":
          filtered = items;
          break;
        case "字符串":
          filtered =
              items.where((element) => element.formats == "plainText").toList();
          break;
        case "图片":
          filtered = items
              .where((element) => ["png"].contains(element.formats))
              .toList();
          break;
        case "其它":
          filtered = items
              .where(
                  (element) => !["png", "plainText"].contains(element.formats))
              .toList();
          break;
        default:
          filtered = items;
          break;
      }
    }

    if (startTime != null && endTime != null) {
      filtered = items
          .where(
              (element) => element.time > startTime && element.time < endTime)
          .toList();
    }

    isFiltered = true;

    notifyListeners();
  }
}
