import 'package:flutter/material.dart';
import 'package:lucky_way_ios/ui/input/address_auto_complete_field.dart';
import 'package:lucky_way_ios/ui/input/custom_input.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';

class AddressHandlerForm extends StatefulWidget {
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
  final Function setName;
  final Function setNotes;
  final String userRole;
  final Function setSenderPhone;
  final Function setSenderEmail;
  final Function setRecipientPhone;
  final Function setRecipientEmail;
  final bool isRetire;

  AddressHandlerForm({
    super.key,
    this.selectedCity,
    this.selectedStreet,
    this.selectedNumber,
    this.selectedPostalCode,
    this.selectedProvince,
    required this.setCity,
    required this.setProvince,
    required this.setStreet,
    required this.setCivicNumber,
    required this.setPostalCode,
    required this.setName,
    required this.setNotes,
    required this.userRole,
    required this.setSenderPhone,
    required this.setSenderEmail,
    required this.setRecipientPhone,
    required this.setRecipientEmail,
    required this.isRetire
  });

  @override
  State<AddressHandlerForm> createState() => _AddressHandlerFormState();
}

class _AddressHandlerFormState extends State<AddressHandlerForm> {
  final String _apiKey = 'AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U';

  Widget phoneAndEmailRender(){
    if(widget.isRetire && widget.userRole == 'recipient'){
      return Column(
        children: [
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setName, label: AppLocalizations.of(context).translate("nameAndLastName"),),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setSenderPhone, label: AppLocalizations.of(context).translate("phone"),),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setSenderEmail, label: AppLocalizations.of(context).translate("emailText"),),
        ],
      );
    } else if(!widget.isRetire && widget.userRole == 'sender'){
      return Column(
        children: [
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setName, label: AppLocalizations.of(context).translate("nameAndLastName"),),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setRecipientPhone, label: AppLocalizations.of(context).translate("phone"),),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setRecipientEmail, label: AppLocalizations.of(context).translate("emailText"),),
        ],
      );
    } else {
      return SizedBox();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate(widget.isRetire ? "insertRetireAddress" : "insertDestinationAddress"), style: greyText18),
          SizedBox(height: 40,),
          phoneAndEmailRender(),
          SizedBox(height: 20,),
          AddressAutocompleteField(
            label: AppLocalizations.of(context).translate(widget.isRetire ? "retireAddress" : "destinationAddress"),
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
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setNotes, label: AppLocalizations.of(context).translate(widget.isRetire ? "retireNotes" : "destinationNotes"),),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
