import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class TimeRangeFormField extends StatefulWidget {
  final String? label;
  final Color backgroundInputColor;
  final Function(TimeOfDay?, TimeOfDay?) updateValue;

  const TimeRangeFormField({
    super.key,
    this.label,
    required this.backgroundInputColor,
    required this.updateValue,
  });

  @override
  State<TimeRangeFormField> createState() => _TimeRangeFormFieldState();
}

class _TimeRangeFormFieldState extends State<TimeRangeFormField> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay initialTime =  TimeOfDay.now();
    final TimeOfDay? pickedInitial = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: initialTime,
        cancelText: AppLocalizations.of(context).translate("cancel"),
        confirmText: AppLocalizations.of(context).translate("ok"),
        helpText: AppLocalizations.of(context).translate("fromHours"),
        errorInvalidText: AppLocalizations.of(context).translate("addATrack"),
        hourLabelText: AppLocalizations.of(context).translate("hours"),
        minuteLabelText: AppLocalizations.of(context).translate("minutes")
    );

    final TimeOfDay? pickedFinal = await showTimePicker(
      cancelText: AppLocalizations.of(context).translate("cancel"),
      confirmText: AppLocalizations.of(context).translate("ok"),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: AppLocalizations.of(context).translate("toHours"),
      errorInvalidText: AppLocalizations.of(context).translate("addATrack"),
      hourLabelText: AppLocalizations.of(context).translate("hours"),
      minuteLabelText: AppLocalizations.of(context).translate("minutes"),
      context: context,
      initialTime: initialTime,
    );
    if (pickedInitial != null && pickedFinal != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedInitial;
          _endTime = pickedFinal;
          // Resetta l'endTime se è precedente allo startTime
          if (_endTime != null &&
              (_endTime!.hour < pickedInitial.hour ||
                  (_endTime!.hour == pickedInitial.hour &&
                      _endTime!.minute < pickedInitial.minute))) {
            _endTime = null;
          }
        } else {
          _endTime = pickedFinal;
        }
        widget.updateValue(_startTime, _endTime);
      });
    }
  }

  String _formatTime(TimeOfDay? startTime,TimeOfDay? endTime) {
    if (startTime == null) return '';
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    if (endTime == null) return '';
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              widget.label!,
              style: blackText14w700,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                context,
                _startTime,
                _endTime,
                    () => _selectTime(context, true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context, TimeOfDay? startTime, TimeOfDay? endTime, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(50),
        color: widget.backgroundInputColor,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            (startTime != null && endTime != null) ? _formatTime(startTime, endTime) : '',
            style: blueText14w700,
          ),
        ),
      ),
    );
  }
}
