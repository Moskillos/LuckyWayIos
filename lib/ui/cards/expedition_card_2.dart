import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/expedition_model.dart';
import '../../utils/date_format.dart';

class ExpeditionCard2 extends StatefulWidget {
  final ExpeditionModel expedition;
  ExpeditionModel? selectedExpedition;
  final Function setSelectedExpedition;

  ExpeditionCard2({super.key, required this.expedition, this.selectedExpedition, required this.setSelectedExpedition});

  @override
  State<ExpeditionCard2> createState() => _ExpeditionCard2State();
}

class _ExpeditionCard2State extends State<ExpeditionCard2> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.setSelectedExpedition(widget.expedition);

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
              Text(widget.expedition.id, style: widget.selectedExpedition == widget.expedition ? whiteText14w700 : blackText14w700),
            ]),
          ],
        ),
      ),
    );
  }
}
