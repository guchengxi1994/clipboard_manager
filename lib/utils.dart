import 'dart:io';

import 'package:clipboard_manager/bridge/native.dart';

class DevUtils {
  static Directory get executableDir =>
      File(Platform.resolvedExecutable).parent;

  static String localeTxtPath = "${DevUtils.executableDir.path}/locale";
  static String watermarkTxtPath = "${DevUtils.executableDir.path}/watermark";
  static String cachePath = "${DevUtils.executableDir.path}/cache";
  static String dbPath = "${DevUtils.executableDir.path}/db.db";
}

Future appInitial() async {
  await api.setDbPath(s: DevUtils.dbPath);
  await api.initDb();
  await api.initFolder(s: DevUtils.cachePath);
  await api.setLocalePath(s: DevUtils.localeTxtPath);
  await api.setWatermarkPath(s: DevUtils.watermarkTxtPath);
}
