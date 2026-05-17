import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';

import '../app_localizations.dart';
import '../costants/text_style.dart';
import '../layout/lucky_way_layout.dart';
import '../ui/buttons/luckyway_btn.dart';

class ConfirmationScreen extends StatefulWidget {
  final String title;
  final Function positiveAnswer;
  const ConfirmationScreen({super.key, required this.title, required this.positiveAnswer});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LuckywayBtn(text: AppLocalizations.of(context).translate("yes"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: widget.positiveAnswer),
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
