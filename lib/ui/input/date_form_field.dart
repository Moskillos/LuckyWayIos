import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../utils/date_format.dart';

class DateFormField extends StatefulWidget {
  final String label;
  final String date;
  final Function setDate;
  const DateFormField({super.key, required this.label, required this.date, required this.setDate});

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  Future<void> _selectDate(BuildContext context) async {

    final DateTime? pickedInitial = await showDatePicker(
      firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        cancelText: AppLocalizations.of(context).translate("cancel"),
        confirmText: AppLocalizations.of(context).translate("ok"),
        helpText: AppLocalizations.of(context).translate("fromHours"),
        errorInvalidText: AppLocalizations.of(context).translate("addATrack"),
    );

    widget.setDate(dateFormat(pickedInitial!));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              widget.label,
              style: blackText14w700,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                context,
                     widget.date,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context, String date,) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: (){
          _selectDate(context);
        } ,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            date,
            style: blueText14w700,
          ),
        ),
      ),
    );
  }
}
