import 'package:clipboard_manager/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingRegion extends StatelessWidget {
  const SettingRegion({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingController>();
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
          ),
        ),
      ),
    );
  }
}
