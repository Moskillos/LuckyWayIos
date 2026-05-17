import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/screens/driver_screens/track_expedition_screen.dart';
import 'package:lucky_way_ios/screens/driver_screens/update_track_state.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/preferences_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import 'delete_track_screen.dart';

class HandlerTrackScreen extends StatefulWidget {
  final TrackModel track;
  const HandlerTrackScreen({super.key, required this.track});

  @override
  State<HandlerTrackScreen> createState() => _HandlerTrackScreenState();
}

class _HandlerTrackScreenState extends State<HandlerTrackScreen> {
  List<PreferencesItem> trackHandlingOptions = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {
      trackHandlingOptions = [
        PreferencesItem(AppLocalizations.of(context).translate("handleTrackExpeditions"), 'assets/cube.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TrackExpeditionScreen(track: widget.track)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("handleTrackStatus"), 'assets/marker.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UpdateTrackState(track: widget.track)),
          );
        }),
        PreferencesItem(AppLocalizations.of(context).translate("deleteTrack"), 'assets/delete.svg', (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => DeleteTrackScreen(track: widget.track,)),
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
            children: List.generate(trackHandlingOptions.length, (index) => itemRender(trackHandlingOptions[index])),
          ),
        ),
        showHeader: true,
        isNavigate: true);
  }
}
