import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';
import 'package:lucky_way_ios/ui/input/custom_input.dart';

import '../app_localizations.dart';
import '../costants/text_style.dart';
import '../layout/lucky_way_layout.dart';
import '../ui/buttons/luckyway_btn.dart';

class ConfirmationScreen extends StatefulWidget {
  final String title;
  final Future<void> Function(String password) positiveAnswer;
  bool? loader;
  ConfirmationScreen({super.key, required this.title, required this.positiveAnswer, this.loader});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool showPasswordInput = false;
  String password = "";

  void deleteAccount(){
    widget.positiveAnswer(password);
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        hideTitle: true,
        title: '',
        button: SizedBox() ,
        content: Expanded(
          child: Container(
              child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Allinea il contenuto al centro
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25),
                              child: Text(
                                widget.title,
                                style: blackText28w700,
                                textAlign: TextAlign.center, // Allinea il testo al centro
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25),
                              child: showPasswordInput ? Column(
                                children: [
                                  Text(AppLocalizations.of(context).translate("yes"), style: whiteText14w700,),
                                  CustomInput(placeholder: AppLocalizations.of(context).translate("insertYourPassword"), updateValue: (value){
                                    setState(() {
                                      password = value;
                                    });
                                  }),
                                  (widget.loader != null && widget.loader == true) ? CircularProgressIndicator() : LuckywayBtn(text: AppLocalizations.of(context).translate("deleteAccount"), backgroundColor: backGroundColor, textStyle: whiteText14w700, onPressed: deleteAccount),
                                ],
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LuckywayBtn(text: AppLocalizations.of(context).translate("yes"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: (){
                                    setState(() {
                                      showPasswordInput = true;
                                    });
                                  }),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  LuckywayBtn(text: AppLocalizations.of(context).translate("no"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: ()async{
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ]
              )
          ),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
