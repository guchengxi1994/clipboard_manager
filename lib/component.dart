import 'dart:typed_data';

import 'package:clipboard_manager/controller.dart';
import 'package:flutter/material.dart';

class Item<T extends BaseModel> extends StatelessWidget {
  const Item({super.key, required this.model});
  final T model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: _buildChild(model),
      ),
    );
    // return Container();
  }

  Widget _buildChild(T model) {
    if (model.formats == "plainText") {
      return Text(model.content.toString());
    }

    if (model.formats == "png") {
      final s = model.content as Uint8List;
      return Image.memory(
        s,
        fit: BoxFit.fitWidth,
      );
    }

    return const Text("未知类型");
  }
}
