import 'package:clipboard_manager/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'layout/layout.dart';
import 'manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ItemController())],
        builder: (context, child) {
          return Layout(
            child: const ClipboardManagerWidget(),
          );
        },
      ),
    );
  }
}
