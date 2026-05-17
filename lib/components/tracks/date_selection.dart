import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/date_form_field.dart';

class DateSelection extends StatefulWidget {
  final String leavingDate;
  final String arriveDate;
  final Function setLeavingDate;
  final Function setArriveDate;
  const DateSelection({super.key, required this.leavingDate, required this.arriveDate, required this.setLeavingDate, required this.setArriveDate});

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).translate("whatDates"), style: greyText18,),
          SizedBox(height: 40,),
          DateFormField(label: AppLocalizations.of(context).translate("leavingDate"), date: widget.leavingDate, setDate: widget.setLeavingDate,),
          SizedBox(height: 20,),
          DateFormField(label: AppLocalizations.of(context).translate("arriveDate"), date: widget.arriveDate, setDate: widget.setArriveDate)
        ],
      ),
    );
  }
}
