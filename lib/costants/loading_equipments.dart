import '../app_localizations.dart';

List<String> loadingEquipments(context){
  return [
    "Sponda idraulica",
    AppLocalizations.of(context).translate("hydraulicCrane"),
    "Verricello",
    AppLocalizations.of(context).translate("forklift"),
    AppLocalizations.of(context).translate("manualPalletTruck"),
    AppLocalizations.of(context).translate("electricPalletTruck"),
    AppLocalizations.of(context).translate("overheadCrane"),
    AppLocalizations.of(context).translate("loadingRamp")
  ];
}

List<String> loadingEquipmentsSender(context){
  return [
    AppLocalizations.of(context).translate("hydraulicCrane"),
    AppLocalizations.of(context).translate("forklift"),
    AppLocalizations.of(context).translate("manualPalletTruck"),
    AppLocalizations.of(context).translate("electricPalletTruck"),
    AppLocalizations.of(context).translate("overheadCrane"),
    AppLocalizations.of(context).translate("loadingRamp"),

  ];
}