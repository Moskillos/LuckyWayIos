import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../ui/buttons/luckyway_btn.dart';

class Presentation extends StatefulWidget {
  final Function changePage;
  final bool showLoader;
  const Presentation({super.key, required this.changePage, required this.showLoader});

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/Logo_E.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/Logo_E.png', width: 300,),

            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50),
              child: Text(AppLocalizations.of(context).translate("presentation"), style: whiteText16, textAlign: TextAlign.center,),
            ),
            Column(
              children: [
                widget.showLoader ? CircularProgressIndicator() : LuckywayBtn(text: AppLocalizations.of(context).translate("goOn"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: widget.changePage,),
                SizedBox(height: 20,),
                Text("@luckyway all rights reserved", style: whiteText16),
              ],
            )

          ],
        ),
      ),
    );
  }
}
