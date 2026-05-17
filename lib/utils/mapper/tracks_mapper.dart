import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../database.dart';
import '../../models/expedition_model.dart';
import '../../models/track_model.dart';
import '../../models/truck_model.dart';
import '../../models/user_model.dart';
import '../track_state_converter.dart';
import '../user_type_converter.dart';

Future<List<TrackModel>> tracksMapper( List<Map<String, dynamic>> tracks)async{
  List<TrackModel> tracksMapped = [];

  for(var track in tracks){
    List<OwnerExModel> customers = [];
    List<LatLng> polylines = [];
    List<ExpeditionModel> expeditions = [];
    List<DriverEvaluation> evaluations = [];

    for(var p in track['polylines']){
      LatLng polyline = LatLng(p['lat'], p['lng']);
      polylines.add(polyline);
    }

    if(track['truckDriver']['evaluations'] != null && track['truckDriver']['evaluations'] is List && track['truckDriver']['evaluations'].isNotEmpty){
      for(var evaluation in track['truckDriver']['evaluations']){
        DriverEvaluation e = DriverEvaluation(evaluation['content'], evaluation['user'], evaluation['userImage'],evaluation['evaluation'] );
        evaluations.add(e);
      }
    }

    TruckModel truck = TruckModel(track['truck']['id'], track['truck']['model'], track['truck']['plate'], track['truck']['truckType'], track['truck']['trailerType'],track['truck']['isAssigned']);
    OwnerExModel truckDriver = OwnerExModel(track['truckDriver']['id'], track['truckDriver']['ownerName'], track['truckDriver']['email'], track['truckDriver']['phone'], track['truckDriver']['token'], userTypeConverter(track['truckDriver']['userType']) , track['truckDriver']['profileImage'], evaluations: evaluations);

    if(track['expeditions'] is List && track['expeditions'].isNotEmpty){

      for(var expedition in track['expeditions']){
        ExpeditionModel expeditionsResponse = await FirebaseDatabase().getExpedition(expedition, null);

        expeditions.add(expeditionsResponse);
      }
    }

    TrackModel t = TrackModel(
        track['id'],
        track['creationDate'],
        track['travelDate'],
        track['travelTime'],
        track['duration'],
        track['distance'],
        track['origin'],
        track['destination'],
        polylines,
        track['image'],
        truck,
        truckDriver,
        customers,
        track['slot'] ?? 0,
        track['availableWeight'] ?? 0,
        track['availableLength'] ?? 0,
      trackStateConverter(track['trackState']),
        track['merchandise'],
      expeditions
    );
    tracksMapped.add(t);
  }
  return tracksMapped;
}