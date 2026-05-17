import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/layout/page_view_builder_layout.dart';
import 'package:lucky_way_ios/screens/onboarding_screens/login_screen.dart';
import 'package:lucky_way_ios/screens/registration_screens/user_type_choose.dart';
import 'package:lucky_way_ios/screens/registration_screens/signup_screen.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../firebase_auth.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../utils/shared_preferencies.dart';

class RegistrationScreens extends StatefulWidget {
  const RegistrationScreens({super.key});

  @override
  State<RegistrationScreens> createState() => _RegistrationScreensState();
}

class _RegistrationScreensState extends State<RegistrationScreens> {
  PageController pageController = PageController(viewportFraction: 1);
  int step = 0;
  bool showLoader = false;
  String userPurpose = '';
  String name = '';
  String lastName = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';
  String vatCode = '';
  String driveLicense = '';
  String code = '';
  bool senderTypeChoosen = false;
  String companyName = '';
  String fiscalCode = '';
  String userId = '';
  String token = '';
  String phone = '';
  String userType = '';
  bool isForm = false;
  String senderType = '';
  String iban = '';
  String uniqueCode = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      senderType = AppLocalizations.of(context).translate("private");
    });
  }

  void changePage() {
    setState(() {
      step = step + 1;
      isForm = true;
    });
    pageController.jumpToPage(step);
  }

  void setUserPurpose(String purpose) {
    setState(() {
      userPurpose = purpose;
    });
  }

  void updateName(String value) {
    setState(() {
      name = value;
    });
  }

  void updateLastName(String value) {
    setState(() {
      lastName = value;
    });
  }

  void updateEmail(String value) {
    setState(() {
      email = value;
    });
  }

  void updatePassword(String value) {
    setState(() {
      password = value;
    });
  }

  void updatePasswordConfirm(String value) {
    setState(() {
      passwordConfirm = value;
    });
  }

  void updateVatCode(String value) {
    setState(() {
      vatCode = value;
    });
  }

  void updateDriveLicense(String value) {
    setState(() {
      driveLicense = value;
    });
  }

  void updateCode(String value) {
    setState(() {
      code = value;
    });
  }

  void updateCompanyName(String value) {
    setState(() {
      companyName = value;
    });
  }

  void updatePhone(String value) {
    setState(() {
      phone = value;
    });
  }

  void updateSenderType(String value) {
    setState(() {
      senderType = value;
    });
  }

  void setIban(String value) {
    setState(() {
      iban = value;
    });
  }

  void setUniqueCode(String value){
    setState(() {
      uniqueCode = value;
    });
  }

  Future<void> signUp()async{
    setState(() {
      showLoader = true;
    });
    String? fToken;
    try {
      fToken = await FirebaseMessaging.instance.getToken();
      print("FCM token: $fToken");
    } catch (e) {
      print('Errore FCM: $e');
    }

    setState(() {
      token = fToken ?? 'FAKE_TOKEN';
    });

    if(userPurpose == 'sender'){
      if(senderType == AppLocalizations.of(context).translate("private")){
        try{
          User? newUser = await Auth()
              .createUserWithEMailAndPassword(
              email: email, password: password);
          if (newUser != null) {
            setState(() {
              userId = newUser.uid;
              userType = 'PHYSICPERSON';
            });
            await settingKeyStorage(userId, password, userType).then((value) => Provider.of<AppState>(context, listen: false)
                .setPrivateUser(PhysicPerson(
                userId,
                name,
                lastName,
                email,
                phone,
                DateTime.now().toIso8601String(),
                '',
                '',
                token,
                [UserType.PHYSICPERSON],
                [],
                UserType.PHYSICPERSON,
                [],
                fiscalCode,
                [],
                []))).then((value) => setState(() {
              showLoader = false;
            })).then((value) => Provider.of<AppState>(context, listen: false).logIn()).then((value) => changePage());
          }
        } catch(e){
          setState(() {
            showLoader = false;
          });
          print(e);
        }

      } else {
        try{
          await Auth()
              .createUserWithEMailAndPassword(
              email: email, password: password)
              ?.then((user) => setState(() {
            userId = user.uid;
            userType = 'LEGALPERSON';
          }))
              .then((value) =>
              settingKeyStorage(userId, password, userType))
              .then((value) =>
              Provider.of<AppState>(context, listen: false)
                  .setCompanyUser(LegalPerson(
                  userId,
                  name,
                  lastName,
                  email,
                  phone,
                  DateTime.now().toIso8601String(),
                  '',
                  '',
                  token,
                  [UserType.GIURIDICPERSON],
                  [],
                  UserType.GIURIDICPERSON,
                  companyName,
                  [],
                  vatCode,
                  uniqueCode,
                  [],
                  []))).then((value) => Provider.of<AppState>(context, listen: false).logIn()).then((value) => setState(() {
            showLoader = false;
          })).then((value) => changePage());
        } catch(e){
          setState(() {
            showLoader = false;
          });
          print(e);
        }

      }
    } else {
      try{
        List<UserType> types = [];
        if(userPurpose == 'both'){
          types.add(UserType.TRUCKDRIVER);
          types.add(UserType.GIURIDICPERSON);
          await Auth()
              .createUserWithEMailAndPassword(
              email: email, password: password)
              ?.then((user) => setState(() {
            userId = user.uid;
            userType = 'TRUCKDRIVER';
          }))
              .then((value) =>
              settingKeyStorage(userId, password, userType))
              .then((value) =>
              Provider.of<AppState>(context, listen: false)
                  .setDriverUser(TruckDriverModel(
                  userId,
                  name,
                  lastName,
                  email,
                  phone,
                  DateTime.now().toIso8601String(),
                  '',
                  '',
                  token ?? '',
                  [UserType.TRUCKDRIVER, UserType.GIURIDICPERSON],
                  [],
                  UserType.TRUCKDRIVER,
                  [],
                  [],
                  driveLicense,
                  code,
                  vatCode,
                  uniqueCode,
                  [],
                  iban
              ))).then((value) => Provider.of<AppState>(context, listen: false)
              .setCompanyUser(LegalPerson(
              userId,
              name,
              lastName,
              email,
              phone,
              DateTime.now().toIso8601String(),
              '',
              '',
              token,
              [UserType.GIURIDICPERSON],
              [],
              UserType.TRUCKDRIVER,
              companyName,
              [],
              vatCode,
              uniqueCode,
              [],
              []))).then((value) => Provider.of<AppState>(context, listen: false).logIn()).then((value) => setState(() {
            showLoader = false;
          }))
              .then((value) => changePage());
        } else {
          types.add(UserType.TRUCKDRIVER);
          await Auth()
              .createUserWithEMailAndPassword(
              email: email, password: password)
              ?.then((user) => setState(() {
            userId = user.uid;
            userType = 'TRUCKDRIVER';
          }))
              .then((value) =>
              settingKeyStorage(userId, password, userType))
              .then((value) =>
              Provider.of<AppState>(context, listen: false)
                  .setDriverUser(TruckDriverModel(
                  userId,
                  name,
                  lastName,
                  email,
                  phone,
                  DateTime.now().toIso8601String(),
                  '',
                  '',
                  token ?? '',
                  [UserType.TRUCKDRIVER, UserType.GIURIDICPERSON],
                  [],
                  UserType.TRUCKDRIVER,
                  [],
                  [],
                  driveLicense,
                  code,
                  vatCode,
                  uniqueCode,
                  [],
                  iban
              ))).then((value) => setState(() {
            showLoader = false;
          }))
              .then((value) => changePage());
        }

      } catch(e){
        setState(() {
          showLoader = false;
        });
        print(e);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      UserTypeChoose(
        userPurpose: userPurpose,
        setUserPurpose: setUserPurpose,
        changePage: changePage,
      ),
      SignupScreen(
        userId: userId,
        userPurpose: userPurpose,
        userType: userType,
        name: name,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        phone: phone,
        vatCode: vatCode,
        token: token,
        driveLicense: driveLicense,
        code: code,
        companyName: companyName,
        fiscalCode: fiscalCode,
        senderType: senderType,
        iban: iban,
        updateCode: updateCode,
        updateCompanyName: updateCompanyName,
        updateDriveLicense: updateDriveLicense,
        updateEmail: updateEmail,
        updateLastName: updateLastName,
        updateName: updateName,
        updatePassword: updatePassword,
        updatePasswordConfirm: updatePasswordConfirm,
        updatePhone: updatePhone,
        updateSenderType: updateSenderType,
        updateVatCode: updateVatCode,
        signUp: signUp,
        setIban: setIban,
      ),
      SuccessScreen(title: AppLocalizations.of(context).translate("registrationSuccess"))
    ];

    return LuckyWayLayout(
      isNavigate: false,
      showHeader: false,
        title: AppLocalizations.of(context).translate("registration"),
        content: PageViewBuilderLayout(pageController: pageController, pages: pages,),
        button: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 30,),
        showLoader ? CircularProgressIndicator() : LuckywayBtn(text: AppLocalizations.of(context).translate("goOn"), backgroundColor: Colors.blue, textStyle: whiteText14w700, onPressed: (){
          if(step == 2){
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => MyHomePage()),
            );
            return;
          }
          if(isForm){
            signUp();
          } else {
            if(userPurpose.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleziona')));
            } else {
              changePage();
            }
          }


        })
      ],
    )); 
  }
}