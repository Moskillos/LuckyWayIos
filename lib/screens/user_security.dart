import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/firebase_auth.dart';
import 'package:lucky_way_ios/main.dart';
import 'package:lucky_way_ios/screens/confirmation_screen.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:lucky_way_ios/utils/shared_preferencies.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../costants/global_color.dart';
import '../costants/text_style.dart';
import '../layout/lucky_way_layout.dart';
import '../models/user_model.dart';
import '../ui/cards/preferences_item.dart';
import '../ui/custom_divider.dart';

class UserSecurity extends StatefulWidget {
  const UserSecurity({super.key});

  @override
  State<UserSecurity> createState() => _UserSecurityState();
}

class _UserSecurityState extends State<UserSecurity> {

  Future<void> deleteAccount(UserBase user)async{
    await Auth().deleteAccount();
    if(user is TruckDriverModel){
      await FirebaseDatabase().deleteDriver(user);
    } else if (user is LegalPerson){
      await FirebaseDatabase().deleteLegalPerson(user);
    } else {
      await FirebaseDatabase().deletePhysicPerson(user as PhysicPerson);
    }
    await removeKeyStorage();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }



  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    Future logOut()async{
      await removeKeyStorage();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Provider.of<AppState>(context, listen: false).logOut();
    }

    return LuckyWayLayout(
        isNavigate: true,
        showHeader: true,
        title: AppLocalizations.of(context).translate("logInAndSecurity"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("logInAndSecurityDesc"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              preferencesItem(
                  AppLocalizations.of(context).translate("passwordText"),
                  AppLocalizations.of(context).translate("changePassword"),
                  SizedBox(), false, () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      title: AppLocalizations.of(context).translate("changePasswordConfirm"),
                      positiveAnswer: () => Auth().resetPassword(user.email),

                    )),
              ), 'assets/pencil_square.svg'
                      ),
              preferencesItem(
                  AppLocalizations.of(context).translate("deleteAccount"),
                  AppLocalizations.of(context).translate("deleteAccount"),
                  SizedBox(),
                  false,
                      () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                            title: AppLocalizations.of(context).translate("deleteAccountQuest"),
                          positiveAnswer: () => deleteAccount(user),)),
                  ), 'assets/pencil_square.svg'),
              preferencesItem(
                  AppLocalizations.of(context).translate("logOut"),
                  AppLocalizations.of(context).translate("logOut"),
                  SizedBox(),
                  false,
                      () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                          title: AppLocalizations.of(context).translate("logOutQuest"),
                          positiveAnswer: () => logOut(),)),
                  ), 'assets/exit.svg'),
            ],
          ),
        ),
        button: SizedBox());
  }
}