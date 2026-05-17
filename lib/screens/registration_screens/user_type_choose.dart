import 'package:flutter/material.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';

import '../../app_localizations.dart';
import '../../ui/cards/selector_widget_card.dart';

class UserTypeChoose extends StatefulWidget {
  final String userPurpose;
  final Function setUserPurpose;
  final Function changePage;
  const UserTypeChoose({super.key, required this.userPurpose, required this.setUserPurpose, required this.changePage});

  @override
  State<UserTypeChoose> createState() => _UserTypeChooseState();
}

class _UserTypeChooseState extends State<UserTypeChoose> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate("registrationPurpose"), style: greyText18),
                SizedBox(height: 40,),
                CustomDivider(),
                SelectorWidgetCard(setUserPurpose: widget.setUserPurpose, type: 'sender', image: 'assets/cube.svg', text: AppLocalizations.of(context).translate("sendAndReceive"), userPurpose: widget.userPurpose,),
                CustomDivider(),
                SelectorWidgetCard(setUserPurpose: widget.setUserPurpose, type: 'driver', image: 'assets/cube.svg', text: AppLocalizations.of(context).translate("deliverArticles"), userPurpose: widget.userPurpose,),
                CustomDivider(),
                SelectorWidgetCard(setUserPurpose: widget.setUserPurpose, type: 'both', image: 'assets/cube.svg', text: AppLocalizations.of(context).translate("deliverArticlesSendAndReceive"), userPurpose: widget.userPurpose,),
                CustomDivider(),
              ],
            ),



          ],
        ),
      ),
    );
  }
}
