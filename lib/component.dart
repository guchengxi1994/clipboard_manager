import 'dart:typed_data';

import 'package:clipboard_manager/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'i18n/component.i18n.dart';

typedef OnCopyClicked = void Function();
typedef OnRemarkChanged = void Function(String s);

class Item<T extends BaseModel> extends StatelessWidget {
  Item(
      {super.key,
      required this.model,
      this.onCopyClicked,
      this.onRemarkChanged});
  final T model;
  final OnCopyClicked? onCopyClicked;
  final OnRemarkChanged? onRemarkChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: _childWrapper(_buildChild(), context),
      ),
    );
    // return Container();
  }

  Widget _buildChild() {
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

    return Text("未知类型".i18n);
  }

  final TextEditingController controller = TextEditingController();

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
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.fromMillisecondsSinceEpoch(model.time)),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                )),
                Container(
                  padding: const EdgeInsets.only(top: 6.5, left: 5, right: 5),
                  width: 200,
                  margin: const EdgeInsets.all(10),
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[200]!)),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 14.5),
                        hintText: "输入备注".i18n,
                        border: InputBorder.none,
                        suffix: InkWell(
                          onTap: () {
                            if (onRemarkChanged != null) {
                              onRemarkChanged!(controller.text);
                            }
                            controller.text = "";
                          },
                          child: const Icon(Icons.check),
                        )),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (onCopyClicked != null) {
                      onCopyClicked!();
                      SmartDialog.showToast("已复制".i18n);
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
          Expanded(child: child),
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 214, 199, 199),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            height: 30,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Text(
                    model.metadata.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
