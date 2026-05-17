import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';
import '../../ui/input/custom_labeled_switch.dart';

class DriverExpeditionOffer extends StatefulWidget {
  final String value;
  final Function onChanged;
  final String firstItem;
  final String secondItem;
  final Function setNewOffer;
  final TextEditingController offerController;
  final String disableText;
  const DriverExpeditionOffer(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.firstItem,
      required this.secondItem,
      required this.offerController,
      required this.setNewOffer,
        required this.disableText});

  @override
  State<DriverExpeditionOffer> createState() => _DriverExpeditionOfferState();
}

class _DriverExpeditionOfferState extends State<DriverExpeditionOffer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate("offerScreenTitle"),
                style: greyText18,
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  AppLocalizations.of(context).translate("doYouAcceptOffer"),
                  style: blackText14w700,
                  textAlign: TextAlign.start,
                ),
              ]),
              CustomLabeledSwitch(
                  onChanged: widget.onChanged,
                  value: widget.value,
                  firstItem: widget.firstItem,
                  secondItem: widget.secondItem),
              SizedBox(
                height: 20,
              ),
              CustomInput(
                  controller: widget.offerController,
                  placeholder:
                      AppLocalizations.of(context).translate("insertLabel"),
                  disable: !(widget.value ==
                      widget.disableText),
                  updateValue: widget.setNewOffer,
                  label: AppLocalizations.of(context).translate("makeYouOffer")),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ));
  }
}
