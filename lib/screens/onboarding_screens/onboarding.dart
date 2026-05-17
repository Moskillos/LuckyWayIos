import 'package:flutter/material.dart';
import 'package:lucky_way_ios/screens/onboarding_screens/presentation.dart';
import 'package:lucky_way_ios/screens/onboarding_screens/welcome.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../costants/text_style.dart';
import 'login_screen.dart';
import 'logo_gif_screen.dart';

class Onboarding extends StatefulWidget {
  final bool showLoader;
  const Onboarding({super.key, required this.showLoader});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController pageController = PageController();
  int step = 0;
  List<Widget> pages = [];



  void changePage(){
    setState(() {
      step = step + 1;
    });
    pageController.jumpToPage(step);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      pages = [
        Presentation(changePage: changePage, showLoader: widget.showLoader),
        LogoGifScreen(changePage: changePage),
        Welcome(changePage: changePage),
        LogInScreen()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        });
  }
}
