import 'package:clipboard_manager/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final ScrollController controller = ScrollController();
  bool searchRegionShow = false;

  final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    node.addListener(() {
      if (node.hasFocus) {
        if (!searchRegionShow) {
          setState(() {
            searchRegionShow = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 215, 213, 205),
              Color.fromARGB(255, 240, 238, 222),
            ]),
      ),
      width: 200,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _searchTextField(),
            _searchRegion(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  List<String> options = ["全部", "字符串", "图片", "其它"];

  String currentSelected = "全部";

  Widget _searchRegion() {
    return Visibility(
        visible: searchRegionShow,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: 200,
          child: Column(
            children: [
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: options
                    .map((e) => InkWell(
                          onTap: () {
                            setState(() {
                              currentSelected = e;
                            });
                          },
                          child: Chip(
                              labelStyle: TextStyle(
                                  color: currentSelected == e
                                      ? Colors.red
                                      : Colors.black),
                              label: Text(e)),
                        ))
                    .toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      currentSelected = "全部";
                      searchRegionShow = false;
                    });
                  },
                  child: const Text("收起"),
                ),
              )
            ],
          ),
        ));
  }

  Widget _searchTextField() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 30,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.search),
          Expanded(
              child: TextField(
            focusNode: node,
            decoration: const InputDecoration(
              hintText: "搜索",
              border: InputBorder.none,
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildContent() {
    final items = context.watch<ItemController>().items;

    final List<BaseModel> filtered;
    switch (currentSelected) {
      case "全部":
        filtered = items;
        break;
      case "字符串":
        filtered =
            items.where((element) => element.formats == "plainText").toList();
        break;
      case "图片":
        filtered = items
            .where((element) => ["png"].contains(element.formats))
            .toList();
        break;
      case "其它":
        filtered = items
            .where((element) => !["png", "plainText"].contains(element.formats))
            .toList();
        break;
      default:
        filtered = items;
        break;
    }

    return Column(
      children: filtered
          .map((e) => InkWell(
                onTap: () {
                  final index = items.indexOf(e);
                  if (index != -1) {
                    context
                        .read<ItemController>()
                        .controller
                        .sliverController
                        .jumpToIndex(index);
                  }
                },
                child: Card(
                  child: Text(e.time.toString()),
                ),
              ))
          .toList(),
    );
  }
}
