import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../components/header.dart';
import '../costants/global_color.dart';
import '../costants/text_style.dart';
import '../layout/lucky_way_layout.dart';
import '../store/app_state.dart';
import '../ui/cards/preferences_item.dart';
import '../ui/custom_divider.dart';
import '../ui/input/modifier_input.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool modifyName = false;
  bool modifyLastname = false;
  bool modifyPhone = false;
  String name = '';
  String lastname = '';
  String phone = '';


  Widget changeInfo(String label, Future<void> Function() changer, Function reset, Function onChange) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: primaryBlue)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          /// Fa sì che l’input prenda tutto lo spazio che può
          Expanded(
            child: ModifierInput(
              label: label,
              placeHolder: AppLocalizations.of(context).translate("insertLabel"),
              updateValue: onChange,
            ),
          ),

          const SizedBox(width: 8),
          InkWell(
            onTap: (){
              reset();
            },
            child: SvgPicture.asset(
              'assets/x.svg',
              color: Colors.black,
              height: 30,
              width: 30,
            ),
          ),
          InkWell(
            onTap: () async {
              await changer();
              reset();
            },
            child: SvgPicture.asset(
              'assets/send.svg',
              color: Colors.black,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }

  void setNameEditing(){
    setState(() {
      modifyName = !modifyName;
    });
  }

  void setName(String value){
    setState(() {
      name = value;
    });
  }

  void resetName(){
    setState(() {
      modifyName = false;
      name = '';
    });
  }

  void setLastNameEditing(){
    setState(() {
      modifyLastname = !modifyLastname;
    });
  }

  void setLastName(String value){
    setState(() {
      lastname = value;
    });
  }

  void resetLastName(){
    setState(() {
      modifyLastname = false;
      lastname = '';
    });
  }

  void setPhoneEditing(){
    setState(() {
      modifyPhone = !modifyPhone;
    });
  }

  void setPhone(String value){
    setState(() {
      phone = value;
    });
  }

  void resetPhone(){
    setState(() {
      modifyPhone = false;
      phone = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return Scaffold(
      body: SingleChildScrollView(  // Wrap the entire content
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // Account for keyboard
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Header(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        AppLocalizations.of(context).translate("userInfo"),
                        style: blackText28w700,
                      ),
                      const SizedBox(height: 20),
                      CustomDivider(),
                      Column(  // Removed inner SingleChildScrollView since we have it at the top level
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("userInfoDesc"),
                            style: greyText18,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          CustomDivider(color: primaryBlue),
                          preferencesItem(
                              AppLocalizations.of(context).translate("editName"),
                              user.name,
                              changeInfo(
                                  AppLocalizations.of(context).translate("editName"),
                                      () => context.read<AppState>().changeName(name),
                                  resetName,
                                  setName
                              ),
                              modifyName,
                              setNameEditing,
                              'assets/pencil_square.svg'
                          ),
                          preferencesItem(
                              AppLocalizations.of(context).translate("editLastname"),
                              user.lastName,
                              changeInfo(
                                  AppLocalizations.of(context).translate("editLastName"),
                                      () => context.read<AppState>().changeLastName(lastname),
                                  resetLastName,
                                  setLastName
                              ),
                              modifyLastname,
                              setLastNameEditing,
                              'assets/pencil_square.svg'
                          ),
                          preferencesItem(
                              AppLocalizations.of(context).translate("editPhone"),
                              user.phone,
                              changeInfo(
                                  AppLocalizations.of(context).translate("editPhone"),
                                      () => context.read<AppState>().changePhone(phone),
                                  resetPhone,
                                  setPhone
                              ),
                              modifyPhone,
                              setPhoneEditing,
                              'assets/pencil_square.svg'
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
