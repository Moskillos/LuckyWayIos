import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/screens/user_security.dart';
import 'package:lucky_way_ios/screens/driver_screens/my_vehicles.dart';
import 'package:lucky_way_ios/screens/privacy_screen.dart';
import 'package:lucky_way_ios/screens/user_info.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/preferences_model.dart';

class DriverPreferences extends StatefulWidget {
  const DriverPreferences({super.key});

  @override
  State<DriverPreferences> createState() => _DriverPreferencesState();
}

class _DriverPreferencesState extends State<DriverPreferences> {
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
        PreferencesItem(AppLocalizations.of(context).translate("myVehicles"), 'assets/truck.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MyVehicles()),
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: primaryBlue),
        ),
      ),
      child: Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        isNavigate: false,
        showHeader: true,
        title: AppLocalizations.of(context).translate("preferences"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("preferencesDesc"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              Column(
                children: List.generate(preferences.length, (index) => itemRender(preferences[index])),
              ),
            ],
          ),
        ),
        button: SizedBox());
  }
}
