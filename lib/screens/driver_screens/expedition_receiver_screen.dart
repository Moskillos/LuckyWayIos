import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/utils/send_call.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';

class ExpeditionReceiverScreen extends StatefulWidget {
  final ExpeditionModel expedition;
  const ExpeditionReceiverScreen({super.key, required this.expedition});

  @override
  State<ExpeditionReceiverScreen> createState() => _ExpeditionReceiverScreenState();
}

class _ExpeditionReceiverScreenState extends State<ExpeditionReceiverScreen> {

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossibile avviare la chiamata a $phoneNumber';
    }
  }

  void copyString(String text){
    Clipboard.setData(ClipboardData(text: text));
  }

  Widget itemRender(String title, String value, String? icon, Function? action){
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
        title: AppLocalizations.of(context).translate("receiver"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("receiverDesc"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              Column(
                children: [
                  itemRender(AppLocalizations.of(context).translate("nameAndLastName"), '${widget.expedition.sender.name}', null, null),
                  itemRender(
                      AppLocalizations.of(context).translate("destinationAddress"),
                      '${widget.expedition.destinationAddress.street}, ${widget.expedition.destinationAddress.civicNumber}, ${widget.expedition.destinationAddress.city}',
                      'assets/copy.svg', copyString),
                  itemRender(AppLocalizations.of(context).translate("phone"), '${widget.expedition.receiver.phone}', 'assets/call.svg', makePhoneCall),
                  // itemRender(AppLocalizations.of(context).translate("chat"), AppLocalizations.of(context).translate("clickToChat"), 'assets/messages.svg', null),
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
