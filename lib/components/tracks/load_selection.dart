import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';
import '../../ui/input/custom_labeled_switch.dart';

class LoadSelection extends StatefulWidget {
  final TextEditingController equipController;
  final String value;
  final Function changeValue;
  final Function setEquip;
  const LoadSelection({super.key, required this.value, required this.changeValue, required this.setEquip, required this.equipController});

  @override
  State<LoadSelection> createState() => _LoadSelectionState();
}

class _LoadSelectionState extends State<LoadSelection> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate("loadEquipment"), style: greyText18,),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(AppLocalizations.of(context).translate("doYouHaveEquip"), style: blackText14w700,),
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
          CustomInput(controller: widget.equipController, placeholder: AppLocalizations.of(context).translate("insertLabel"), disable: !(widget.value == AppLocalizations.of(context).translate("no")), updateValue: widget.setEquip, label: AppLocalizations.of(context).translate("whatEquipYouHave"), minLines: 5, maxLines: 5,),
        ],
      ),
    );
  }
}
