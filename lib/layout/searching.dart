import 'package:clipboard_manager/item_controller.dart';
import 'package:clipboard_manager/searching_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_useful_widgets/flutter_useful_widgets.dart';
import 'package:provider/provider.dart';

import '../i18n/searching.i18n.dart';

class SearchingRegion extends StatelessWidget {
  const SearchingRegion({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SearchingController>();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _wrapper(
                    "日期选择".i18n,
                    UsefulDateRangePicker(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 15),
                      calendarWidth: 350,
                      onDatePicked: (dates) {
                        final d1 = dates[0]!.millisecondsSinceEpoch;
                        final d2 = dates[1]!.millisecondsSinceEpoch;

                        context
                            .read<ItemController>()
                            .getFiltered(startTime: d1, endTime: d2);
                      },
                      multiRow: MediaQuery.of(context).size.width > 800
                          ? false
                          : true,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(19)),
                          color: Colors.white,
                          border: Border.all(color: Colors.white)),
                    )),
                const SizedBox(
                  height: 30,
                ),
                _wrapper(
                    "类型选择".i18n,
                    Expanded(
                        child: Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: SearchingController.options
                          .map((e) => InkWell(
                                onTap: () {
                                  controller.changeCurrentSelected(e);
                                  context
                                      .read<ItemController>()
                                      .getFiltered(type: e);
                                },
                                child: Chip(
                                    labelStyle: TextStyle(
                                        color: controller.currentSelected == e
                                            ? Colors.red
                                            : Colors.black),
                                    label: Text(e)),
                              ))
                          .toList(),
                    ))),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        controller.changeCurrentSelected(
                            SearchingController.options.first);
                        context.read<ItemController>().clearFiltered();
                      },
                      child: Text("重置".i18n),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<SearchingController>()
                            .changeVisible(false);
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
