import 'package:flutter/material.dart';

class LogoGifScreen extends StatelessWidget {
  final Function changePage;
  const LogoGifScreen({super.key, required this.changePage});

  Future<void> changePageIn5Seconds()async{
    Future.delayed(Duration(seconds: 3), () {
      changePage();
    });
  }

  @override
  Widget build(BuildContext context) {

    changePageIn5Seconds();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/lucky_way_animation.gif',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
