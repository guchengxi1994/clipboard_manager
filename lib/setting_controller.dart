import 'dart:typed_data';

import 'package:clipboard_manager/bridge/native.dart';
import 'package:clipboard_manager/extension.dart';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;

typedef CInitPaddleFunction = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef InitPaddleFunction = void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

typedef CBytesRegFunc = ffi.Pointer<Utf8> Function(
    ffi.Pointer<ffi.Uint8> input, ffi.Int32 inLength);

typedef BytesRegFunc = ffi.Pointer<Utf8> Function(
    ffi.Pointer<ffi.Uint8> input, int inLength);

class SettingController extends ChangeNotifier {
  bool show = false;
  // String watermark = "xiaoshuyui";
  late String watermark = "";

  init() async {
    watermark = await api.getWatermark();
    notifyListeners();
  }

  bool isInited = false;

  late final ffi.DynamicLibrary lib;

  bool autoExtractText = false;
  changeExtractText(bool b) {
    if (autoExtractText != b) {
      autoExtractText = b;
      notifyListeners();
      if (!isInited) {
        Future.delayed(Duration.zero).then((v) {
          initOcr();
        });
      }
    }
  }

  String infer(Uint8List data) {
    final r = detectBytes(data, lib);
    return r;
  }

  initOcr() {
    lib = ffi.DynamicLibrary.open("./ppocr.dll");
    final InitPaddleFunction init = lib
        .lookup<ffi.NativeFunction<CInitPaddleFunction>>("InitPaddle")
        .asFunction();
    init(
        r"D:\PaddleOCR-2.6.0\models\ch_PP-OCRv3_rec_infer".toNativeUtf8(),
        r"D:\PaddleOCR-2.6.0\models\ch_PP-OCRv3_det_infer".toNativeUtf8(),
        r"D:\PaddleOCR-2.6.0\models\ppocr_keys_v1.txt".toNativeUtf8());
    isInited = true;
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

String detectBytes(Uint8List input, ffi.DynamicLibrary lib) {
  final BytesRegFunc func = lib
      .lookup<ffi.NativeFunction<CBytesRegFunc>>("ImageBytesProcess")
      .asFunction();
  final result = func(input.allocatePointer(), input.length);
  return result.toDartString();
}
