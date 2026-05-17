
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../firebase_auth.dart' show Auth;
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';
import '../../ui/input/custom_input.dart';
import '../../utils/mapper/user_mapper.dart';
import '../registration_screens/registration_screens.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool showLoader = false;
  bool signInMode = false;
  String email = '';
  String password = '';

  void updateEmail(String value){
    setState(() {
      email = value;
    });
  }

  void updatePassword(String value){
    setState(() {
      password = value;
    });
  }



  @override
  Widget build(BuildContext context) {

    Future<void> searchUserByEmail(String email) async {
      final firestore = FirebaseFirestore.instance;
      final collections = ['truckDrivers', 'physicPersons', 'legalPersons'];

      for (String collection in collections) {
        final querySnapshot = await firestore
            .collection(collection)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;

          if(doc.data()["userView"] == UserType.TRUCKDRIVER){
            TruckDriverModel user = await truckDriverMapper(doc.data());
            Provider.of<AppState>(context, listen: false)
                .setDriverUser(user);
          } else if (doc.data()["userView"] == UserType.GIURIDICPERSON){
            LegalPerson user = await legalPersonMapper(doc.data());
            Provider.of<AppState>(context, listen: false)
                .setCompanyUser(user);
          } else {
            PhysicPerson user = await physicPersonMapper(doc.data());
            Provider.of<AppState>(context, listen: false)
                .setPrivateUser(user);
          }
        }
      }

    }

    Future<void> logIn() async {
      await Auth().signInWithEMailAndPassword(email: email, password: password).then((value) async => await  searchUserByEmail(email));
    }

    Widget signInForm(){
      return Form(
        key: _formSignInKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60,),
                  Text("logIn", style: whiteText28w700,),
                  const SizedBox(height: 20,),
                  CustomDivider(color: Colors.white,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInput(label: "emailText",placeholder: "insertYourEmail",icon: Icons.email, updateValue: updateEmail, textStyle: blackText14, backgroundInputColor: Colors.white,),
                  const SizedBox(height: 20,),
                  CustomInput(label: "passwordText",placeholder: "insertYourPassword",icon: Icons.lock, updateValue: updatePassword,textStyle: blackText14, isPassword: true, backgroundInputColor: Colors.white, ),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      TextButton(onPressed: () async {
                        await Auth().resetPassword(email);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("recoveryEmailSent")));
                        Navigator.of(context).pop();
                      }, child: Text("passwordForgetText", style: whiteText14Underline, textAlign: TextAlign.end,)),
                    ],
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
              Column(
                children: [
                  !showLoader ? LuckywayBtn(text: "logIn", backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: () async {
                    await logIn();
                  }) : SpinKitWave(
                    color: grey,
                    size: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("doNotHaveAccount", style: whiteText14,),
                      SizedBox(width: 5,),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreens()),
                            );
                          },
                          child: Text("signUp", style: whiteText14Underline)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),

      );
    }

      return Scaffold(
        backgroundColor: primaryBlue,
          body: signInForm());
    }
  }
