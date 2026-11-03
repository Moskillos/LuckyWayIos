import 'package:flutter/material.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../utils/date_format.dart';

class ExpeditionCard2 extends StatefulWidget {
  final TrackModel track;
  final ExpeditionModel expedition;
  ExpeditionModel? selectedExpedition;
  final Function setSelectedExpedition;

  ExpeditionCard2({super.key, required this.expedition, this.selectedExpedition, required this.setSelectedExpedition, required this.track});

  @override
  State<ExpeditionCard2> createState() => _ExpeditionCard2State();
}

class _ExpeditionCard2State extends State<ExpeditionCard2> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.expedition.id == "null"){
          return;
        }
        widget.setSelectedExpedition(widget.expedition);

      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)
                    .translate("warning"),
                style: blueText16w700,
              ),
              content: Text(
                AppLocalizations.of(context)
                    .translate("expeditionDeleting"),
                style: blackText14,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await FirebaseDatabase().deleteExpeditionOnTrack(widget.expedition.id, widget.track.id);
                  },
                  child: Text(AppLocalizations.of(context)
                      .translate("delete")),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: widget.selectedExpedition == widget.expedition ? primaryBlue : null,
            border: Border.all(color: grey, width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate("date"),
                  style: widget.selectedExpedition == widget.expedition ? whiteText14 : blackText14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  dateFormat(DateTime.now()),
                  style: widget.selectedExpedition == widget.expedition ? whiteText14w700 : blackText14w700,
                )
              ],
            ),
            Row(children: [
              Text(
                AppLocalizations.of(context).translate("track"),
                style: widget.selectedExpedition == widget.expedition ? whiteText14 : blackText14,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                  '${widget.expedition.retireAddress.city} - ${widget.expedition.destinationAddress.city}',
                  style: widget.selectedExpedition == widget.expedition ? whiteText14w700 : blackText14w700),
            ]),
            Row(children: [
              Text(
                AppLocalizations.of(context).translate("sender2"),
                style: widget.selectedExpedition == widget.expedition ? whiteText14 : blackText14,
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.expedition.sender.name, style: widget.selectedExpedition == widget.expedition ? whiteText14w700 : blackText14w700),
            ]),
            Row(children: [
              Text(
                AppLocalizations.of(context).translate("expeditionCode"),
                style: widget.selectedExpedition == widget.expedition ? whiteText14 : blackText14,
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(child: Text(widget.expedition.equipment == "deleted" ? AppLocalizations.of(context).translate("deletedExpedition") : widget.expedition.id, style: widget.selectedExpedition == widget.expedition ? whiteText14w700 : blackText14w700)),
            ]),
          ],
        ),
      ),
    );
  }
}
