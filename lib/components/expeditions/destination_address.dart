import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/address_auto_complete_field.dart';
import '../../ui/input/custom_input.dart';

class DestinationAddress extends StatefulWidget {
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
  final Function setDestinataryName;
  final Function setDestinationNotes;
  DestinationAddress({super.key, required this.setCity, required this.setProvince, required this.setStreet, required this.setCivicNumber, required this.setPostalCode, required this.setDestinataryName, required this.setDestinationNotes, this.selectedCity, this.selectedStreet, this.selectedNumber, this.selectedPostalCode, this.selectedProvince,});

  @override
  State<DestinationAddress> createState() => _DestinationAddressState();
}

class _DestinationAddressState extends State<DestinationAddress> {
  final String _apiKey = 'AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(AppLocalizations.of(context).translate("insertRetireAddress"), style: greyText18),
        SizedBox(height: 40,),
        CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinataryName, label: AppLocalizations.of(context).translate("nameAndLastname"),),
        SizedBox(height: 20,),
        AddressAutocompleteField(
          label: AppLocalizations.of(context).translate("destinationAddress"),
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
        SizedBox(height: 20,),
        CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationNotes, label: AppLocalizations.of(context).translate("destinationNotes"),),
        SizedBox(height: 80,),
      ],
    );
  }
}
