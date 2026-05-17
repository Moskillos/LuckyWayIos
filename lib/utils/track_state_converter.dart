

import '../app_localizations.dart';
import '../models/track_model.dart';

TrackStates trackStateConverter(String state){
  if(state == 'COMPLETED'){
    return TrackStates.COMPLETED;
  } else if(state == 'STARTED'){
    return TrackStates.STARTED;
  } else if(state == 'ONTHEWAY'){
    return TrackStates.ONTHEWAY;
  } else {
    return TrackStates.CREATED;
  }
}

String trackStateEnumConverter(TrackStates trackState){
  if(trackState == TrackStates.STARTED){
    return 'STARTED';
  } else if(trackState == TrackStates.ONTHEWAY){
    return 'ONTHEWAY';
  } else if(trackState == TrackStates.COMPLETED){
    return 'COMPLETED';
  } else {
    return 'CREATED';
  }
}