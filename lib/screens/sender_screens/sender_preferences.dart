import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/screens/privacy_screen.dart';
import 'package:lucky_way_ios/screens/user_info.dart';
import 'package:lucky_way_ios/screens/user_security.dart';
import 'package:lucky_way_ios/ui/cards/selector_widget_card_2.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/preferences_model.dart';



class SenderPreferences extends StatefulWidget {
  const SenderPreferences({super.key});

  @override
  State<SenderPreferences> createState() => _SenderPreferencesState();
}

class _SenderPreferencesState extends State<SenderPreferences> {
  List<PreferencesItem> preferences = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {
      preferences = [
        PreferencesItem(AppLocalizations.of(context).translate("userInfo"), 'assets/profile.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UserInfo()),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("logInAndSecurity"), 'assets/shield-check.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UserSecurity()),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("privacy"), 'assets/hand.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => PrivacyScreen()),
          );
        })
      ];
    });
  }

  Widget itemRender(PreferencesItem item){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: InkWell(
        onTap: item.action,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black
              ),
              child: SvgPicture.asset(
                item.icon,
                color: Colors.white,
                height: 30,
                width: 30,
              ),
            ),
            SizedBox(width: 10,),
            Text(item.title, style: blackText14w700,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        isNavigate: false,
        showHeader: false,
        title: AppLocalizations.of(context).translate("preferences"),
        content: Column(
          children: List.generate(preferences.length, (index) => itemRender(preferences[index])),
        ),
        button: SizedBox());
  }
}
