import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';
import '../../utils/send_call.dart';

class ExpeditionSenderScreen extends StatefulWidget {
  final ExpeditionModel expedition;
  const ExpeditionSenderScreen({super.key, required this.expedition});

  @override
  State<ExpeditionSenderScreen> createState() => _ExpeditionSenderScreenState();
}

class _ExpeditionSenderScreenState extends State<ExpeditionSenderScreen> {

  Future<void> makePhoneCall(String phoneNumber, String caller) async {
    print('phoneNumber');
    print('caller');
    print(phoneNumber);
    print(caller);
    await sendCall(caller, phoneNumber);
  }

  void copyString(String text){
    Clipboard.setData(ClipboardData(text: text));
  }

  Widget itemRender(String title, String value, String? icon, Function? action, Function? action2, Function? action3){
    String number = '+39${context.watch<AppState>().user.phone}8';

    return Column(
      children: [
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: blackText14w700,),
                Text(value, style: blueText14,)
              ],
            ),
            if(icon != null)InkWell(
              onTap: (){
                if (action != null) {
                  action(value);
                } else if(action2 != null){
                  action2(value, number);
                }
              },
              child: SvgPicture.asset(
                icon,
                color: Colors.black,
                height: 30,
                width: 30,
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        CustomDivider(color: primaryBlue,),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        isNavigate: false,
        showHeader: false,
        title: AppLocalizations.of(context).translate("sender"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("senderDesc"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              Column(
                children: [
                  itemRender(AppLocalizations.of(context).translate("nameAndLastName"), '${widget.expedition.sender.name}', null, null, null,null),
                  itemRender(
                      AppLocalizations.of(context).translate("retireAddress"),
                      '${widget.expedition.retireAddress.street}, ${widget.expedition.retireAddress.civicNumber}, ${widget.expedition.retireAddress.city}',
                      'assets/copy.svg', copyString, null , null),
                  itemRender(AppLocalizations.of(context).translate("phone"), '+39${widget.expedition.sender.phone}', 'assets/call.svg', null, makePhoneCall, null),
                  // itemRender(AppLocalizations.of(context).translate("chat"), AppLocalizations.of(context).translate("clickToChat"), 'assets/messages.svg', null, null, null),
                ],
              ),
            ],
          ),
        ),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: AppLocalizations.of(context).translate("goBack"), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: 'assets/back-arrow.svg', onPressed: (){
              Navigator.of(context).pop();
            }),
          ],
        ));
  }
}
