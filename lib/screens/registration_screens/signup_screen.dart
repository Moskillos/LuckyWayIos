import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';
import '../../ui/input/custom_labeled_switch.dart';

class SignupScreen extends StatefulWidget {
  final String userPurpose;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirm;
  final String vatCode;
  final String driveLicense;
  final String code;
  final String companyName;
  final String fiscalCode;
  final String userId;
  final String token;
  final String phone;
  final String userType;
  final String senderType;
  final String iban;
  final Function updateCompanyName;
  final Function updateVatCode;
  final Function updateEmail;
  final Function updatePasswordConfirm;
  final Function updatePassword;
  final Function updateName;
  final Function updateLastName;
  final Function updateCode;
  final Function updateDriveLicense;
  final Function updatePhone;
  final Function updateSenderType;
  final Function signUp;
  final Function setIban;

  const SignupScreen(
      {super.key,
      required this.userPurpose,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      required this.passwordConfirm,
      required this.vatCode,
      required this.driveLicense,
      required this.code,
      required this.companyName,
      required this.fiscalCode,
      required this.userId,
      required this.token,
      required this.phone,
      required this.userType,
      required this.iban,
      required this.senderType,
      required this.updateCompanyName,
      required this.updateVatCode,
      required this.updateEmail,
      required this.updatePasswordConfirm,
      required this.updatePassword,
      required this.updateName,
      required this.updateLastName,
      required this.updateSenderType,
      required this.signUp,
      required this.updateCode,
      required this.updateDriveLicense,
      required this.updatePhone,
      required this.setIban});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool showLoader = false;
  bool accepted = false;

  Widget signUpCompanyForm() {
    return Form(
      key: _formSignInKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("companyName"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updateCompanyName,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
              label: AppLocalizations.of(context).translate("vatCode"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateVatCode,
              textStyle: blackText14),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
              label: AppLocalizations.of(context).translate("uniqueCode"),
              placeholder:
              AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateVatCode,
              textStyle: blackText14),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("emailText"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updateEmail,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("phone"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updatePhone,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("passwordText"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updatePassword,
            textStyle: blackText14,
            isPassword: true,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
              label:
                  AppLocalizations.of(context).translate("passwordConfirm"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updatePasswordConfirm,
              textStyle: blackText14,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              children: [
                Checkbox(
                    value: accepted,
                    onChanged: (value) {
                      setState(() {
                        accepted = !accepted;
                      });
                    }),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color:
                            Colors.black, // Stile di default per tutto il testo
                        fontSize: 16, // Dimensione del testo di default
                      ),
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)
                                .translate("treatmentPersonalDataText")),
                        TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("privacyPolicy"),
                          style: const TextStyle(
                            decoration: TextDecoration
                                .underline, // Stile diverso per questa parte del testo
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle the tap
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    content: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate("closeText")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("termsAndConditions"),
                          style: const TextStyle(
                            decoration: TextDecoration
                                .underline, // Stile diverso per questa parte del testo
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle the tap
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)
                                            .translate("termsAndConditions"),
                                        style: blackText14),
                                    content: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate("close")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                        ),
                        TextSpan(
                            text:
                                AppLocalizations.of(context).translate("dot")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget signUpPrivateForm() {
    return Form(
      key: _formSignInKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("name"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updateName,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
              label: AppLocalizations.of(context).translate("lastName"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateLastName,
              textStyle: blackText14),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("emailText"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updateEmail,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("phone"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updatePhone,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("taxCode"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updateVatCode,
            textStyle: blackText14,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            label: AppLocalizations.of(context).translate("passwordText"),
            placeholder: AppLocalizations.of(context).translate("insertLabel"),
            updateValue: widget.updatePassword,
            textStyle: blackText14,
            isPassword: true,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
              label: AppLocalizations.of(context).translate("passwordConfirm"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updatePasswordConfirm,
              textStyle: blackText14,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              children: [
                Checkbox(
                    value: accepted,
                    onChanged: (value) {
                      setState(() {
                        accepted = !accepted;
                      });
                    }),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color:
                            Colors.black, // Stile di default per tutto il testo
                        fontSize: 16, // Dimensione del testo di default
                      ),
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)
                                .translate("treatmentPersonalDataText")),
                        TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("privacyPolicy"),
                          style: const TextStyle(
                            decoration: TextDecoration
                                .underline, // Stile diverso per questa parte del testo
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle the tap
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    content: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate("closeText")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("termsAndConditions"),
                          style: const TextStyle(
                            decoration: TextDecoration
                                .underline, // Stile diverso per questa parte del testo
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle the tap
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)
                                            .translate("termsAndConditions"),
                                        style: blackText14),
                                    content: Text(
                                      AppLocalizations.of(context)
                                          .translate("privacyPolicy"),
                                      style: blackText14,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate("close")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                        ),
                        TextSpan(
                            text:
                                AppLocalizations.of(context).translate("dot")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget senderForm() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context).translate("insertYourData"),
              style: greyText18,
            ),
            SizedBox(
              height: 40,
            ),
            CustomLabeledSwitch(
              value: widget.senderType,
              onChanged: (String value) {
                widget.updateSenderType(value);
              },
              firstItem: AppLocalizations.of(context).translate("private"),
              secondItem: AppLocalizations.of(context).translate("company"),
            ),
            widget.senderType ==
                    AppLocalizations.of(context).translate("private")
                ? signUpPrivateForm()
                : signUpCompanyForm()
          ],
        ),
      ),
    );
  }

  Widget signUpDriverForm() {
    return Form(
      key: _formSignInKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              AppLocalizations.of(context).translate("insertYourData"),
              style: greyText18,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("name"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateName,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
                label: AppLocalizations.of(context).translate("lastName"),
                placeholder:
                    AppLocalizations.of(context).translate("insertLabel"),
                updateValue: widget.updateLastName,
                textStyle: blackText14),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("emailText"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateEmail,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("phone"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updatePhone,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("vatCode"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateVatCode,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label:
                  AppLocalizations.of(context).translate("driveLicenseNumber"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateDriveLicense,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("thirdPartyLicense"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updateCode,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
                CustomInput(
                    label: AppLocalizations.of(context).translate("uniqueCode"),
                    placeholder:
                    AppLocalizations.of(context).translate("insertLabel"),
                    updateValue: widget.updateVatCode,
                    textStyle: blackText14),
                const SizedBox(
                  height: 20,
                ),
            CustomInput(
              label: AppLocalizations.of(context).translate("iban"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.setIban,
              textStyle: blackText14,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              label: AppLocalizations.of(context).translate("passwordText"),
              placeholder:
                  AppLocalizations.of(context).translate("insertLabel"),
              updateValue: widget.updatePassword,
              textStyle: blackText14,
              isPassword: true,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
                label: AppLocalizations.of(context)
                    .translate("passwordConfirm"),
                placeholder:
                    AppLocalizations.of(context).translate("insertLabel"),
                updateValue: widget.updatePasswordConfirm,
                textStyle: blackText14,
                isPassword: true),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                children: [
                  Checkbox(
                      value: accepted,
                      onChanged: (value) {
                        setState(() {
                          accepted = !accepted;
                        });
                      }),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors
                              .black, // Stile di default per tutto il testo
                          fontSize: 16, // Dimensione del testo di default
                        ),
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate("treatmentPersonalDataText")),
                          TextSpan(
                            text: AppLocalizations.of(context)
                                .translate("privacyPolicy"),
                            style: const TextStyle(
                              decoration: TextDecoration
                                  .underline, // Stile diverso per questa parte del testo
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the tap
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        AppLocalizations.of(context)
                                            .translate("privacyPolicy"),
                                        style: blackText14,
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context)
                                            .translate("privacyPolicy"),
                                        style: blackText14,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("closeText")),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                          ),
                          const TextSpan(text: ' & '),
                          TextSpan(
                            text: AppLocalizations.of(context)
                                .translate("termsAndConditions"),
                            style: const TextStyle(
                              decoration: TextDecoration
                                  .underline, // Stile diverso per questa parte del testo
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the tap
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          AppLocalizations.of(context)
                                              .translate("termsAndConditions"),
                                          style: blackText14),
                                      content: Text(
                                        AppLocalizations.of(context)
                                            .translate("privacyPolicy"),
                                        style: blackText14,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("close")),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate("dot")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.userPurpose == 'sender' ? senderForm() : signUpDriverForm();
  }
}
