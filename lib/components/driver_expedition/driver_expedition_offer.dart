import 'package:flutter/material.dart';
import 'package:lucky_way_ios/costants/text_style.dart';

import '../../app_localizations.dart';

class DriverExpeditionOffer extends StatefulWidget {
  final String value;
  final Function onChanged;
  final String firstItem;
  final String secondItem;
  final Function setNewOffer;
  final TextEditingController offerController;
  final String disableText;
  final int offer;
  const DriverExpeditionOffer(
      {super.key,
        required this.value,
        required this.onChanged,
        required this.firstItem,
        required this.secondItem,
        required this.offerController,
        required this.setNewOffer,
        required this.disableText,
        required this.offer});

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
              Text(
                AppLocalizations.of(context).translate("offer2"),
                style: blackText28w700,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${widget.offer.toString()}€',
                style: blackText28w700,
                textAlign: TextAlign.start,
              )
            ],
          ),
        ));
  }
}
