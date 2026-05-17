import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/screens/driver_screens/expedition_info_screen.dart';
import 'package:lucky_way_ios/screens/driver_screens/expedition_sender_screen.dart';
import 'package:lucky_way_ios/screens/driver_screens/update_expedition_state.dart';
import 'package:lucky_way_ios/screens/negative_question_screen.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/preferences_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import 'expedition_receiver_screen.dart';

class HandlerExpeditionScreen extends StatefulWidget {
  final ExpeditionModel expedition;
  final TrackModel track;
  const HandlerExpeditionScreen({super.key, required this.expedition, required this.track});

  @override
  State<HandlerExpeditionScreen> createState() => _HandlerExpeditionScreenState();
}

class _HandlerExpeditionScreenState extends State<HandlerExpeditionScreen> {
  List<PreferencesItem> expeditionHandlingOptions = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {
      expeditionHandlingOptions = [
        PreferencesItem(AppLocalizations.of(context).translate("seeExpeditionDetails"), 'assets/info.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ExpeditionInfoScreen(expedition: widget.expedition)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("seeSenderDetails"), 'assets/identification.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ExpeditionSenderScreen(expedition: widget.expedition)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("seeReceiverDetails"), 'assets/identification.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ExpeditionReceiverScreen(expedition: widget.expedition)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("updateExpeditionStatus"), 'assets/marker.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UpdateExpeditionState(expedition: widget.expedition,)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("expeditionRenunciation"), 'assets/x-circle.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NegativeQuestionScreen(track: widget.track, expedition: widget.expedition)),
          );
        }),
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
        title: AppLocalizations.of(context).translate("tracks"),
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
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: List.generate(expeditionHandlingOptions.length, (index) => itemRender(expeditionHandlingOptions[index])),
          ),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
