import 'package:clipboard_manager/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class SettingRegion extends StatelessWidget {
  SettingRegion({super.key});
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingController>();
    textController.text = controller.watermark;
    return IgnorePointer(
      ignoring: !controller.show,
      child: AnimatedOpacity(
        opacity: controller.show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Card(
          elevation: 8,
          child: Container(
            width: 0.8 * (MediaQuery.of(context).size.width - 200),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _wrapper(
                    "水印文字",
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 6.5, left: 5, right: 5),
                          width: 200,
                          margin: const EdgeInsets.all(10),
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!)),
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 14.5),
                                hintText: "输入水印文字",
                                border: InputBorder.none,
                                suffix: InkWell(
                                  onTap: () {
                                    controller
                                        .changeWatermark(textController.text);
                                    SmartDialog.showToast("成功");
                                  },
                                  child: const Icon(Icons.check),
                                )),
                          ),
                        ),
                        const Text("(仅支持英文和数字)")
                      ],
                    )),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        context.read<SettingController>().changeVisible(false);
                      },
                      child: const Text("收起"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapper(String title, Widget child) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(title),
        ),
        child
      ],
    );
  }
}
