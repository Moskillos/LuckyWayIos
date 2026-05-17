import 'package:flutter/material.dart';

import '../components/header.dart';
import '../costants/text_style.dart';
import '../ui/custom_divider.dart';
import '../utils/web_friendly_scroll_behavior.dart';

class LuckyWayLayout extends StatefulWidget {
  final String title;
  final Widget button;
  final Widget content;
  final bool showHeader;
  final bool isNavigate;
  bool? hideTitle;
  bool? hidePadding;
  bool? hideDivider;
  LuckyWayLayout({super.key, required this.title, required this.button, required this.content, required this.showHeader, required this.isNavigate, this.hideTitle, this.hidePadding, this.hideDivider});

  @override
  State<LuckyWayLayout> createState() => _LuckyWayLayoutState();
}

class _LuckyWayLayoutState extends State<LuckyWayLayout> {
  @override
  Widget build(BuildContext context) {
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      floatingActionButton: keyboardOpen ? null : widget.button,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              children: [
                SizedBox(height: widget.isNavigate ? 40 : 10,),
                if(widget.showHeader)Header(),
                if(widget.hideTitle == null)Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      widget.title,
                      style: blackText28w700,
                    ),
                    const SizedBox(height: 20),
                    if(widget.hideDivider == null)CustomDivider(),
                  ],
                ),
              ],
            ),
          ),
          widget.content
        ],
      ),
    );
  }
}
