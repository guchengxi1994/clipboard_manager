// ignore_for_file: avoid_init_to_null, use_build_context_synchronously

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:provider/provider.dart';
import 'package:super_clipboard/super_clipboard.dart';

import 'component.dart';
import 'controller.dart';

class Model extends BaseModel {
  Model({required super.content, required super.formats, required super.time});

  @override
  Future delete() async {}

  @override
  Future save() async {}
}

class ClipboardManagerWidget extends StatefulWidget {
  const ClipboardManagerWidget({super.key});

  @override
  State<ClipboardManagerWidget> createState() => _ClipboardManagerWidgetState();
}

class _ClipboardManagerWidgetState extends State<ClipboardManagerWidget>
    with ClipboardListener {
  @override
  void initState() {
    clipboardWatcher.addListener(this);
    // start watch
    clipboardWatcher.start();
    super.initState();
  }

  @override
  void dispose() {
    clipboardWatcher.removeListener(this);
    // stop watch
    clipboardWatcher.stop();
    super.dispose();
  }

  @override
  void onClipboardChanged() async {
    final reader = await ClipboardReader.readClipboard();

    if (reader.canProvide(Formats.htmlText)) {
      final html = await reader.readValue(Formats.htmlText);
      context.read<ItemController>().addItem(Model(
          content: html,
          formats: "htmlText",
          time: DateTime.now().millisecondsSinceEpoch));
    }

    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      context.read<ItemController>().addItem(Model(
          content: text,
          formats: "plainText",
          time: DateTime.now().millisecondsSinceEpoch));
    }

    if (reader.canProvide(Formats.png)) {
      reader.getFile(Formats.png, (file) async {
        final stream = file.getStream();
        final data = await stream.toList();
        context.read<ItemController>().addItem(Model(
            content: data.first,
            formats: "png",
            time: DateTime.now().millisecondsSinceEpoch));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemController>().items;
    return FlutterListView(
        controller: context.read<ItemController>().controller,
        delegate: FlutterListViewDelegate(
            childCount: items.length,
            (context, index) => Item(
                  model: items[index],
                )));
  }
}
