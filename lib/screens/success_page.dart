import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';

import '../app_localizations.dart';
import '../costants/text_style.dart';
import '../ui/buttons/luckyway_btn.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
      hideTitle: true,
        title: '',
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: AppLocalizations.of(context).translate("goOn"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: ()async{
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
          ],
        ) ,
        content: Expanded(
          child: Container(
              child: SuccessScreen(title: AppLocalizations.of(context).translate("requestSuccessSent"), description: AppLocalizations.of(context).translate("waitDriverAnswer"),)),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
