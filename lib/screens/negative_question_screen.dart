import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../costants/text_style.dart';
import '../layout/lucky_way_layout.dart';
import '../store/app_state.dart';
import '../ui/buttons/luckyway_btn.dart';

class NegativeQuestionScreen extends StatefulWidget {
  final TrackModel track;
  final ExpeditionModel expedition;
  const NegativeQuestionScreen({super.key, required this.track, required this.expedition});

  @override
  State<NegativeQuestionScreen> createState() => _NegativeQuestionScreenState();
}

class _NegativeQuestionScreenState extends State<NegativeQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        hideTitle: true,
        hideDivider: true,
        title: '',
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: AppLocalizations.of(context).translate("yes"), backgroundColor: Colors.white, textStyle: blackText14w700, onPressed: (){
              Provider.of<AppState>(context, listen: false).deleteExpeditionFromTrack(widget.track, widget.expedition);
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: AppLocalizations.of(context).translate("no"), backgroundColor: Colors.white, textStyle: blackText14w700, onPressed: (){
              Navigator.of(context).pop();
            }),
          ],
        ),
        content: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/delete.svg',
                      color: Colors.white,
                      height: 80,
                      width: 80,
                    ),
                  ),
                  SizedBox(height: 60,),
                  Text(AppLocalizations.of(context).translate("deleteTrackExpedition"), style: whiteText28w700, textAlign: TextAlign.center),
                  SizedBox(height: 40,),
                  Text(AppLocalizations.of(context).translate("deleteTrackExpeditionDesc"), style: whiteText14w700, textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
