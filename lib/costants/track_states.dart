import 'package:lucky_way_ios/models/track_model.dart';

import '../app_localizations.dart';

class TrackStatesDropValues{
  String title;
  TrackStates trackStates;

  TrackStatesDropValues(this.title, this.trackStates);
}

List<TrackStatesDropValues> trackStates(context){
  return [
    TrackStatesDropValues(AppLocalizations.of(context).translate("created"), TrackStates.CREATED),
    TrackStatesDropValues(AppLocalizations.of(context).translate("onTheWay"), TrackStates.ONTHEWAY),
    TrackStatesDropValues(AppLocalizations.of(context).translate("leftNow"), TrackStates.STARTED),
    TrackStatesDropValues(AppLocalizations.of(context).translate("completed"), TrackStates.COMPLETED),
  ];
}