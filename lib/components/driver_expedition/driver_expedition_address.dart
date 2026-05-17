import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/address_auto_complete_field.dart';
import '../../ui/input/custom_input.dart';

class DriverExpeditionAddress extends StatefulWidget {
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  final Function setCity;
  final Function setProvince;
  final Function setStreet;
  final Function setCivicNumber;
  final Function setPostalCode;
  DriverExpeditionAddress({
    super.key,
    required this.setCity,
    required this.setProvince,
    required this.setStreet,
    required this.setCivicNumber,
    required this.setPostalCode,
    this.selectedCity,
    this.selectedStreet,
    this.selectedNumber,
    this.selectedProvince,
    this.selectedPostalCode
  });

  @override
  State<DriverExpeditionAddress> createState() => _DriverExpeditionAddressState();
}

class _DriverExpeditionAddressState extends State<DriverExpeditionAddress> {
  final String _apiKey = 'AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U';
  bool manualAddress = false;

  void setManualAddress(){
    setState(() {
      manualAddress = !manualAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate("insertLeavingAddress"), style: greyText18,),
          SizedBox(height: 40,),
          manualAddress ? Column(
            children: [
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setStreet, label: AppLocalizations.of(context).translate("street"),),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setCivicNumber, label: AppLocalizations.of(context).translate("civicNumber"),),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setPostalCode, label: AppLocalizations.of(context).translate("postalCode"),),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setProvince, label: AppLocalizations.of(context).translate("province"),),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setCity, label: AppLocalizations.of(context).translate("city"),)
            ],
          ) : AddressAutocompleteField(
            label: AppLocalizations.of(context).translate("retireAddress"),
            apiKey: _apiKey,
            selectedCity: widget.selectedCity,
            selectedStreet: widget.selectedStreet,
            selectedPostalCode: widget.selectedPostalCode,
            selectedNumber: widget.selectedNumber,
            selectedProvince: widget.selectedProvince,
            setCity: widget.setCity,
            setStreet: widget.setStreet,
            setCivicNumber: widget.setCivicNumber,
            setPostalCode: widget.setPostalCode,
            setProvince: widget.setProvince,
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: (){
                    setManualAddress();
                  },
                  child: Text(manualAddress ? AppLocalizations.of(context).translate("goBack") : AppLocalizations.of(context).translate("addressNotFound"), style: blueText14Underline,)),
            ],
          ),

          SizedBox(height: 70,),
        ],
      ),
    );
  }
}
