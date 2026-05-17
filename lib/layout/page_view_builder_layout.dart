import 'package:flutter/material.dart';

import '../utils/web_friendly_scroll_behavior.dart';

class PageViewBuilderLayout extends StatefulWidget {
  final PageController pageController;
  final List<Widget> pages;
  const PageViewBuilderLayout({super.key, required this.pageController, required this.pages});

  @override
  State<PageViewBuilderLayout> createState() => _PageViewBuilderLayoutState();
}

class _PageViewBuilderLayoutState extends State<PageViewBuilderLayout> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: WebFriendlyScrollBehavior(),
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: widget.pageController,
          itemCount: widget.pages.length,
          itemBuilder: (context, index) => widget.pages[index],
        ),
      ),
    );
  }
}
