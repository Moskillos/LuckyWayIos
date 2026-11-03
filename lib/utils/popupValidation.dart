import 'package:flutter/material.dart';

import '../app_localizations.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> popUpValidation(String missing, context){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${AppLocalizations.of(context).translate("miss")} $missing")));
}