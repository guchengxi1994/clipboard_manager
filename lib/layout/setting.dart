import 'package:clipboard_manager/bridge/native.dart';
import 'package:clipboard_manager/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_useful_widgets/flutter_useful_widgets.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import '../i18n/setting.i18n.dart';

class SettingRegion extends StatefulWidget {
  const SettingRegion({super.key});

  @override
  State<SettingRegion> createState() => _SettingRegionState();
}

class _SettingRegionState extends State<SettingRegion> {
  final TextEditingController textController = TextEditingController();

  late String lang = "中文";

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
                    "水印文字".i18n,
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
                                hintText: "输入水印文字".i18n,
                                border: InputBorder.none,
                                suffix: InkWell(
                                  onTap: () async {
                                    await controller
                                        .changeWatermark(textController.text);
                                    SmartDialog.showToast("成功".i18n);
                                  },
                                  child: const Icon(Icons.check),
                                )),
                          ),
                        ),
                        Text("(仅支持英文和数字)".i18n)
                      ],
                    )),
                _wrapper(
                    "切换语言".i18n,
                    SimpleDropdownButton(
                        hint: "选择语言".i18n,
                        value: lang,
                        dropdownItems: const ["中文", "English"],
                        onChanged: (v) async {
                          if (v == "中文") {
                            I18n.of(context).locale = const Locale("zh", "CN");
                            await api.setLocale(s: "zh");
                          } else {
                            I18n.of(context).locale = const Locale('en', "US");
                            await api.setLocale(s: "en");
                          }
                          setState(() {
                            lang = v!;
                          });
                        })),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        context.read<SettingController>().changeVisible(false);
                      },
                      child: Text("收起".i18n),
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
