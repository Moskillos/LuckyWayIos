import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/address_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../app_localizations.dart';
import '../costants/text_style.dart';
import '../models/user_model.dart';
import '../store/app_state.dart';
import '../ui/buttons/main_btn.dart';
import '../ui/input/custom_input.dart';



class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressModel> addresses = [];
  String street = '';
  String city = '';
  String province = '';
  String civicNumber = '';
  String cap = '';

  void updateStreet(String value){
    setState(() {
      street = value;
    });
  }

  void updateCivicNumber(String value){
    setState(() {
      civicNumber = value;
    });
  }

  void updateCity(String value){
    setState(() {
      city = value;
    });
  }

  void updateProvince(String value){
    setState(() {
      province = value;
    });
  }

  void updateCap(String value){
    setState(() {
      cap = value;
    });
  }

  Future showAddressModal() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate("withdrawAddress"),
                      style: blackText14,
                    ),
                    // CustomInput(
                    //   placeholder: AppLocalizations.of(context)
                    //       .translate("street"),
                    //   updateValue: updateStreet,
                    //   padding: 0,
                    // ),
                    // CustomInput(
                    //   placeholder: AppLocalizations.of(context)
                    //       .translate("civicNumber"),
                    //   updateValue: updateCivicNumber,
                    //   padding: 0,
                    // ),
                    // CustomInput(
                    //   placeholder:
                    //   AppLocalizations.of(context).translate("city"),
                    //   updateValue: updateCity,
                    //   padding: 0,
                    // ),
                    // CustomInput(
                    //   placeholder: AppLocalizations.of(context)
                    //       .translate("province"),
                    //   updateValue: updateProvince,
                    //   padding: 0,
                    // ),
                    // CustomInput(
                    //   placeholder: AppLocalizations.of(context)
                    //       .translate("postalCode"),
                    //   updateValue: updateCap,
                    //   padding: 0,
                    // ),
                    SizedBox(height: 20),
                    MainBtn(
                      onPressed: () {
                        AddressModel newAddress = AddressModel(
                            const Uuid().v4(),
                            street,
                            int.parse(civicNumber),
                            city,
                            province,
                            int.parse(cap));
                        Provider.of<AppState>(context, listen: false)
                            .addNewAddress(newAddress);
                        Navigator.of(context).pop();
                      },
                      text: AppLocalizations.of(context)
                          .translate("saveAddress"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    if(user is LegalPerson){
      setState(() {
        addresses = user.addresses;
      });
    } else if(user is PhysicPerson){
      setState(() {
        addresses = user.addresses;
      });
    }



    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: (){
                showAddressModal();
              },
              child: Text('+'),
            ),
          )
        ],
      ),
      body: Column(
        children: List.generate(addresses.length, (index) => Container(
          child: Row(
            children: [
              Text('${addresses[index].city}, ${addresses[index].street} ${addresses[index].civicNumber} - ${addresses[index].cap} ${addresses[index].province}'),
            ],
          ),
        )),
      ),
    );
  }
}
