import 'package:clipboard_manager/item_controller.dart';
import 'package:clipboard_manager/searching_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final ScrollController controller = ScrollController();

  final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    node.addListener(() {
      if (node.hasFocus) {
        context.read<SearchingController>().changeVisible(true);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _searchTextField(),
          Expanded(
              child: SingleChildScrollView(
            controller: controller,
            child: _buildContent(),
          )),
          Container(
              width: 180,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 10,
                    ),
                    Text("设置"),
                    Expanded(child: SizedBox()),
                    Icon(Icons.chevron_right)
                  ],
                ),
              )),
        ],
      ),
    );
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
    final c = context.watch<ItemController>();
    List<BaseModel> filtered = !c.isFiltered ? c.items : c.filtered;

    return Column(
      children: filtered
          .map((e) => InkWell(
                onTap: () {
                  final index = c.items.indexOf(e);
                  if (index != -1) {
                    context
                        .read<ItemController>()
                        .controller
                        .sliverController
                        .jumpToIndex(index);
                  }
                },
                child: Card(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 180,
                      child: Text(
                        e.metadata["uuid"].toString().split("-").first,
                      )),
                ),
              ))
          .toList(),
    );
  }
}
