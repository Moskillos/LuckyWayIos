import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/address_auto_complete_field.dart';
import '../../ui/input/custom_input.dart';

class AddressesSelection extends StatefulWidget {
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  String? selectedDestinationCity;
  String? selectedDestinationStreet;
  String? selectedDestinationNumber;
  String? selectedDestinationPostalCode;
  String? selectedDestinationProvince;
  final Function setCity;
  final Function setProvince;
  final Function setStreet;
  final Function setCivicNumber;
  final Function setPostalCode;
  final Function setDestinationCity;
  final Function setDestinationProvince;
  final Function setDestinationStreet;
  final Function setDestinationCivicNumber;
  final Function setDestinationPostalCode;
  AddressesSelection({
    super.key,
    this.selectedCity,
    this.selectedProvince,
    this.selectedStreet,
    this.selectedNumber,
    this.selectedPostalCode,
    this.selectedDestinationCity,
    this.selectedDestinationProvince,
    this.selectedDestinationStreet,
    this.selectedDestinationNumber,
    this.selectedDestinationPostalCode,
    required this.setCity,
    required this.setProvince,
    required this.setStreet,
    required this.setCivicNumber,
    required this.setPostalCode,
    required this.setDestinationCity,
    required this.setDestinationProvince,
    required this.setDestinationStreet,
    required this.setDestinationCivicNumber,
    required this.setDestinationPostalCode,

  });

  @override
  State<AddressesSelection> createState() => _AddressesSelectionState();
}

class _AddressesSelectionState extends State<AddressesSelection> {
  final String apiKey = 'AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U';
  bool manualAddress = false;
  bool manualDestinationAddress = false;

  void setManualAddress(){
    setState(() {
      manualAddress = !manualAddress;
    });
  }

  void setManualDestinationAddress(){
    setState(() {
      manualDestinationAddress = !manualDestinationAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context).translate("whatAddresses"), style: greyText18,),
            SizedBox(height: 20,),
            manualAddress ? Column(
              children: [
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setStreet, label: AppLocalizations.of(context).translate("street"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setCivicNumber, label: AppLocalizations.of(context).translate("civicNumber"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setPostalCode, label: AppLocalizations.of(context).translate("postalCode"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setProvince, label: AppLocalizations.of(context).translate("province"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setCity, label: AppLocalizations.of(context).translate("city"),),

              ],
            ) :AddressAutocompleteField(
              label: AppLocalizations.of(context).translate("leavingAddress"),
                apiKey: apiKey,
                setCity: widget.setCity,
                setProvince: widget.setProvince,
                setStreet: widget.setStreet,
                setCivicNumber: widget.setCivicNumber,
                setPostalCode: widget.setPostalCode,
              selectedCity: widget.selectedCity,
                selectedProvince: widget.selectedProvince,
              selectedStreet: widget.selectedStreet,
              selectedNumber: widget.selectedNumber,
              selectedPostalCode: widget.selectedPostalCode,
            ),
            InkWell(
                onTap: (){
                  setManualAddress();
                },
                child: Text(manualAddress ? AppLocalizations.of(context).translate("goBack") : AppLocalizations.of(context).translate("addressNotFound"), style: blueText14Underline,)),
            SizedBox(height: 20,),
            manualDestinationAddress ? Column(
              children: [
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationStreet, label: AppLocalizations.of(context).translate("street"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationCivicNumber, label: AppLocalizations.of(context).translate("civicNumber"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationPostalCode, label: AppLocalizations.of(context).translate("postalCode"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationProvince, label: AppLocalizations.of(context).translate("province"),),
                CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setDestinationCity, label: AppLocalizations.of(context).translate("city"),),
              ],
            ) :AddressAutocompleteField(
              label: AppLocalizations.of(context).translate("destinationAddress"),
              apiKey: apiKey,
              setCity: widget.setDestinationCity,
              setProvince: widget.setDestinationProvince,
              setStreet: widget.setDestinationStreet,
              setCivicNumber: widget.setDestinationCivicNumber,
              setPostalCode: widget.setDestinationPostalCode,
              selectedCity: widget.selectedDestinationCity,
              selectedProvince: widget.selectedDestinationProvince,
              selectedStreet: widget.selectedDestinationStreet,
              selectedNumber: widget.selectedDestinationNumber,
              selectedPostalCode: widget.selectedDestinationPostalCode,
            ),
            SizedBox(height: 10,),
            InkWell(
                onTap: (){
                  setManualDestinationAddress();
                },
                child: Text(manualDestinationAddress ? AppLocalizations.of(context).translate("goBack") : AppLocalizations.of(context).translate("addressNotFound"), style: blueText14Underline,)),
            SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}
