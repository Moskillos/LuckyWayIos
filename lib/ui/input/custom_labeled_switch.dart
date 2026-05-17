import 'package:flutter/material.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class CustomLabeledSwitch extends StatefulWidget {
  final String value;
  final String firstItem;
  final String secondItem;
  final Function onChanged;

  const CustomLabeledSwitch({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.firstItem,
    required this.secondItem,
  }) : super(key: key);

  @override
  _CustomLabeledSwitchState createState() => _CustomLabeledSwitchState();
}

class _CustomLabeledSwitchState extends State<CustomLabeledSwitch>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primaryBlue, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.value == widget.firstItem
                    ? primaryBlue
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  widget.onChanged(widget.firstItem);
                },
                child: Text(
                  widget.firstItem,
                  style: widget.value == widget.firstItem
                      ? whiteText14w700
                      : blueText14w700,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.value == widget.secondItem
                    ? primaryBlue
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  widget.onChanged(widget.secondItem);
                },
                child: Text(
                  widget.secondItem,
                  style: widget.value == widget.secondItem
                      ? whiteText14w700
                      : blueText14w700,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
