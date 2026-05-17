import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';
import '../../ui/input/custom_labeled_switch.dart';

class TrackDeviation extends StatefulWidget {
  final TextEditingController kmController;
  final String value;
  final Function changeValue;
  final Function setKm;
  const TrackDeviation({super.key, required this.value, required this.changeValue, required this.setKm, required this.kmController});

  @override
  State<TrackDeviation> createState() => _TrackDeviationState();
}

class _TrackDeviationState extends State<TrackDeviation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context).translate("deviationQuestion"), style: greyText18,),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(AppLocalizations.of(context).translate("deviationLabel"), style: blackText14w700,),
            ),
            CustomLabeledSwitch(
              value: widget.value,
              onChanged: (String value) {
                widget.changeValue(value);
              }   ,
              firstItem: AppLocalizations.of(context).translate("yes"),
              secondItem: AppLocalizations.of(context).translate("no"),
            ),
            SizedBox(height: 20,),
            CustomInput(controller: widget.kmController, placeholder: AppLocalizations.of(context).translate("insertLabel"),disable: !(widget.value == AppLocalizations.of(context).translate("no")), updateValue: widget.setKm, label: AppLocalizations.of(context).translate("howManyKm"), textInputType: TextInputType.number,),
          ],
        ),
      ),
    );
  }
}
