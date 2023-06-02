// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:clipboard_manager/bridge/native.dart';
import 'package:clipboard_manager/item_controller.dart';
import 'package:clipboard_manager/setting_controller.dart';
import 'package:clipboard_manager/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';

import 'layout/layout.dart';
import 'manager.dart';
import 'searching_controller.dart';

String locale = "zh";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appInitial();
  locale = await api.getLocale();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      title: locale == "zh" ? "剪切板管理工具" : "Clipboard manager",
      size: const Size(1280, 720),
      minimumSize: const Size(1280, 720),
      center: false,
      // backgroundColor: Colors.transparent,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('zh', "CN"),
      ],
      theme: ThemeData(
        fontFamily: "思源",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: I18n(
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (locale == "zh") {
        I18n.of(context).locale = const Locale("zh", "CN");
      } else {
        I18n.of(context).locale = const Locale('en', "US");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ItemController()),
          ChangeNotifierProvider(create: (_) => SearchingController()),
          ChangeNotifierProvider(create: (_) => SettingController()..init())
        ],
        builder: (context, child) {
          return Layout(
            child: const ClipboardManagerWidget(),
          );
        },
      ),
    );
  }
}
