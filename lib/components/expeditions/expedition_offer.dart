import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';

class ExpeditionOffer extends StatefulWidget {
  final Function setOffer;
  final Function setSpecialRequest;
  const ExpeditionOffer({super.key, required this.setOffer, required this.setSpecialRequest});

  @override
  State<ExpeditionOffer> createState() => _ExpeditionOfferState();
}

class _ExpeditionOfferState extends State<ExpeditionOffer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate("offerDescr"), style: greyText18),
          SizedBox(height: 40,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setOffer, label: AppLocalizations.of(context).translate("offer"), textInputType: TextInputType.number,),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setSpecialRequest, label: AppLocalizations.of(context).translate("specialRequestsForDriver"),),
        ],
      ),
    );
  }
}
