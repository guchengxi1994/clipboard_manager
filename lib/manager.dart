// ignore_for_file: avoid_init_to_null, use_build_context_synchronously

import 'dart:async';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:provider/provider.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'component.dart';
import 'item_controller.dart';

class Model extends BaseModel {
  Model(
      {required super.content,
      required super.formats,
      required super.time,
      super.metadata});

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
    Future.microtask(() async {
      font = img.BitmapFont.fromZip(await loadAsset());
    });
  }

  @override
  void dispose() {
    clipboardWatcher.removeListener(this);
    // stop watch
    clipboardWatcher.stop();
    super.dispose();
  }

  Future<Uint8List> loadAsset() async {
    return Uint8List.view(
        (await rootBundle.load('assets/fonts/SourceHanSans-VF.ttf.zip'))
            .buffer);
  }

  // ignore: prefer_typing_uninitialized_variables
  late final font;

  bool shouldUpdate = true;

  Future skipUpdate() async {
    setState(() {
      shouldUpdate = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      shouldUpdate = true;
    });
  }

  @override
  void onClipboardChanged() async {
    if (!shouldUpdate) {
      return;
    }

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
        var imageData = data.first;
        img.Image? image = img.decodePng(imageData);

        if (image != null) {
          image = img.drawString(image, "xiaoshuyui", font: font);
          imageData = img.encodePng(image);

          final item = DataWriterItem();
          item.add(Formats.png(imageData));
          await ClipboardWriter.instance.write([item]);
          skipUpdate();
        }

        final (width, height) = await getImageSize(imageData);

        context.read<ItemController>().addItem(Model(
            content: imageData,
            formats: "png",
            metadata: {"width": width.toString(), "height": height.toString()},
            time: DateTime.now().millisecondsSinceEpoch));
      });
    }
  }

  Future<(int, int)> getImageSize(Uint8List data) async {
    var image = Image.memory(data);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));

    ui.Image info = await completer.future;
    return (info.width, info.height);
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
                  onCopyClicked: () async {
                    final item = DataWriterItem();
                    if (items[index].formats == "plainText") {
                      item.add(Formats.plainText(items[index].content));
                    }
                    if (items[index].formats == "htmlText") {
                      item.add(Formats.htmlText(items[index].content));
                    }

                    if (items[index].formats == "png") {
                      item.add(Formats.png(items[index].content));
                    }
                    skipUpdate();
                    await ClipboardWriter.instance.write([item]);
                  },
                )));
  }
}
