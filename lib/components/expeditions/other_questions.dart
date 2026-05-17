import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../ui/custom_divider.dart';

class OtherQuestions extends StatefulWidget {
  final Function setIsFlammable;
  final Function setEquip;
  final Function setIsFragile;
  final bool isFragile;
  final bool isFlammable;
  const OtherQuestions({super.key, required this.setIsFlammable, required this.setEquip, required this.setIsFragile, required this.isFragile, required this.isFlammable});

  @override
  State<OtherQuestions> createState() => _OtherQuestionsState();
}

class _OtherQuestionsState extends State<OtherQuestions> {
  bool hasEquip = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate("lastExpeditionStep"), style: greyText18),
          SizedBox(height: 40,),
          CustomDivider(color: primaryBlue),
          Row(
            children: [
              Checkbox(value: hasEquip, onChanged: (bool? value) {
                setState(() {
                  hasEquip = value!;
                });
              }),
              SizedBox(width: 10,),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 220
                ),
                  child: Text(AppLocalizations.of(context).translate("haveTheEquip"), style: blackText14,))
            ],
          ),
          if(hasEquip)Column(
            children: [

            ],
          ),
          CustomDivider(color: primaryBlue),
          Row(
            children: [
              Checkbox(value: widget.isFlammable, onChanged: (bool? value) {
                widget.setIsFlammable();
              }),
              SizedBox(width: 10,),
              Text(AppLocalizations.of(context).translate("isFlammable"), style: blackText14,)
            ],
          ),
          CustomDivider(color: primaryBlue),
          Row(
            children: [
              Checkbox(value: widget.isFragile, onChanged: (bool? value) {
                widget.setIsFragile();
              }),
              SizedBox(width: 10,),
              Text(AppLocalizations.of(context).translate("isFragile"), style: blackText14,)
            ],
          ),
          CustomDivider(color: primaryBlue),
        ],
      ),
    );
  }
}
