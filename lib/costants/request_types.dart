import '../app_localizations.dart';

List<String> requestTypes(context){
  return [
    AppLocalizations.of(context).translate("improvement"),
    AppLocalizations.of(context).translate("bug")
  ];
}