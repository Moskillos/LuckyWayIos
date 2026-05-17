import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/track_model.dart';

class TrackCard2 extends StatefulWidget {
  final TrackModel track;
  final Function setTrack;
  const TrackCard2({super.key, required this.track, required this.setTrack});

  @override
  State<TrackCard2> createState() => _TrackCard2State();
}

class _TrackCard2State extends State<TrackCard2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.setTrack(widget.track);
        },
        child: Container(
            padding: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: primaryBlue)
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("date"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text(widget.track.travelDate, style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("track"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text('${widget.track.origin} - ${widget.track.destination}', style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("driver"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text('${widget.track.truckDriver.ownerName}', style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("trackCode"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text(widget.track.id, style: blackText14w700,),
                    ],
                  ),
                ],
              ),
            ))
    );
  }
}
