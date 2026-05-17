import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/buttons/luckyway_btn.dart';

class Welcome extends StatefulWidget {
  final Function changePage;
  const Welcome({super.key, required this.changePage});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/logo.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logo.png', width: 75,),
                  SizedBox(height: 50,),
                  Text(AppLocalizations.of(context).translate("welcome"), style: blackText28w700,),
                  SizedBox(height: 50,),
                  Text(AppLocalizations.of(context).translate("welcomeDescription"), style: blueText16w700,),
                  SizedBox(height: 50,),
                  Text(AppLocalizations.of(context).translate("welcomeDescription2"), style: blackText14,),

                ],
              ),
              Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(AppLocalizations.of(context).translate("welcomeDescription3"), style: blackText14w700ita,)),
              LuckywayBtn(text: AppLocalizations.of(context).translate("letStart"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: (){
                widget.changePage();
              })
            ],
          ),
        ),
      ),
    );
  }
}