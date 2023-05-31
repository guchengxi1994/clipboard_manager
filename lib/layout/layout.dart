// ignore_for_file: must_be_immutable

import 'package:clipboard_manager/layout/sidemenu.dart';
import 'package:flutter/material.dart';

import 'searching.dart';

class Layout extends StatelessWidget {
  Layout({super.key, required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const SideMenu(), Expanded(child: child)],
                ),
                const Positioned(left: 200, child: SearchingRegion())
              ],
            ),
          )
        ],
      ),
    );
  }
}
