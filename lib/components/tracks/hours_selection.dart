import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/time_form_field.dart';

class HoursSelection extends StatefulWidget {
  final Function setLeavingTime;
  final Function setArriveTime;
  String? arriveTime;
  String? leavingTime;
  HoursSelection({super.key, required this.setLeavingTime, required this.setArriveTime, this.arriveTime, this.leavingTime});

  @override
  State<HoursSelection> createState() => _HoursSelectionState();
}

class _HoursSelectionState extends State<HoursSelection> {
  TimeOfDay startLeavingTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endLeavingTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay startArriveTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endArriveTime = TimeOfDay(hour: 0, minute: 0);

  void updateLeavingTime(TimeOfDay? startTime, TimeOfDay? endTime){
    setState(() {
      startLeavingTime = startTime!;
      endLeavingTime = endTime!;
    });
    widget.setLeavingTime('${startTime?.hour}:${startTime?.minute} - ${endTime?.hour}:${endTime?.minute}');
  }

  void updateDestinationTime(TimeOfDay? startTime, TimeOfDay? endTime){
    setState(() {
      startArriveTime = startTime!;
      endArriveTime = endTime!;
    });
    widget.setArriveTime('${startTime?.hour}:${startTime?.minute} - ${endTime?.hour}:${endTime?.minute}');
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).translate("whatHours"), style: greyText18,),
          SizedBox(height: 40,),
          TimeRangeFormField(
              backgroundInputColor: Colors.white,
              updateValue: updateLeavingTime,
            label: AppLocalizations.of(context).translate("deliveryTime"),
          ),
          SizedBox(height: 20,),
          TimeRangeFormField(
            backgroundInputColor: Colors.white,
            updateValue: updateDestinationTime,
            label: AppLocalizations.of(context).translate("deliveryDestinationTime"),
          )
        ],
      ),
    );
  }
}
