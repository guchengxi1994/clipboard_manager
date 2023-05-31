import 'dart:typed_data';

import 'package:clipboard_manager/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

typedef OnCopyClicked = void Function();

class Item<T extends BaseModel> extends StatelessWidget {
  const Item({super.key, required this.model, this.onCopyClicked});
  final T model;
  final OnCopyClicked? onCopyClicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: _childWrapper(_buildChild(model), context),
      ),
    );
    // return Container();
  }

  Widget _buildChild(T model) {
    if (model.formats == "plainText") {
      return Text(model.content.toString());
    }

    if (model.formats == "htmlText") {
      // return Text(model.content.toString());
      return Html(data: model.content.toString());
    }

    if (model.formats == "png") {
      final s = model.content as Uint8List;
      return Image.memory(
        s,
        fit: BoxFit.fitHeight,
      );
    }

    return const Text("未知类型");
  }

  Widget _childWrapper(Widget child, BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey[300]!, width: 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Text(
                    model.formats,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  DateTime.fromMillisecondsSinceEpoch(model.time).toString(),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                )),
                InkWell(
                  onTap: () async {
                    if (onCopyClicked != null) {
                      onCopyClicked!();
                      SmartDialog.showToast("Copied");
                    }
                  },
                  child: const Icon(
                    Icons.copy,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    context.read<ItemController>().removeItem(model);
                  },
                  child: const Icon(
                    Icons.close,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
