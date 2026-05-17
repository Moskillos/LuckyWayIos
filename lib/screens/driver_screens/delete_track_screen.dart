import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/track_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';

class DeleteTrackScreen extends StatefulWidget {
  final TrackModel track;
  const DeleteTrackScreen({super.key, required this.track});

  @override
  State<DeleteTrackScreen> createState() => _DeleteTrackScreenState();
}

class _DeleteTrackScreenState extends State<DeleteTrackScreen> {
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
            LuckywayBtn(text: AppLocalizations.of(context).translate("delete"), backgroundColor: Colors.white, textStyle: blackText14w700, onPressed: (){
              Provider.of<AppState>(context, listen: false).deleteTrack(widget.track);
              Navigator.popUntil(context, (route) => route.isFirst);
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
                  Text(AppLocalizations.of(context).translate("deleteTrackTitle"), style: whiteText28w700, textAlign: TextAlign.center),
                  SizedBox(height: 40,),
                  Text(AppLocalizations.of(context).translate("deleteTrackDescription"), style: whiteText14w700, textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
