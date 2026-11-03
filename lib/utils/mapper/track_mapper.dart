import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucky_way_ios/models/address_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/utils/track_state_converter.dart';

import '../../database.dart';
import '../../models/expedition_model.dart';
import '../../models/truck_model.dart';
import '../user_type_converter.dart';

Future<TrackModel> trackMapper(Map<String, dynamic> track)async{
  List<OwnerExModel> customers = [];
  List<LatLng> polylines = [];
  List<ExpeditionModel> expeditions = [];
  List<AddressModel> trackPoints = [];
  List<DriverEvaluation> evaluations = [];

  for(var p in track['polylines']){
    LatLng polyline = LatLng(p['lat'], p['lng']);
    polylines.add(polyline);
  }

  if(track['truckDriver']['evaluations'] != null && track['truckDriver']['evaluations'] is List && track['truckDriver']['evaluations'].isNotEmpty){
    for(var evaluation in track['truckDriver']['evaluations']){
      DriverEvaluation e = DriverEvaluation(evaluation['content'], evaluation['user'], evaluation['userImage'],double.parse(evaluation['evaluation']) );
      evaluations.add(e);
    }
  }

  TruckModel truck = TruckModel(track['truck']['id'], track['truck']['model'], track['truck']['plate'], track['truck']['truckType'], track['truck']['trailerType'],track['truck']['isAssigned']);

  OwnerExModel truckDriver = OwnerExModel(track['truckDriver']['id'], track['truckDriver']['ownerName'], track['truckDriver']['email'], track['truckDriver']['phone'], track['truckDriver']['token'], userTypeConverter(track['truckDriver']['userType']) ,track['truckDriver']['profileImage'], fiscalCode: track['truckDriver']['fiscalCode'], vatNumber: track['truckDriver']['vatNumber'], evaluations: evaluations);

  if(track['expeditions'] is List && track['expeditions'].isNotEmpty){
    for(var expedition in track['expeditions']){
      ExpeditionModel expeditionsResponse = await FirebaseDatabase().getExpedition(expedition, null);
      expeditions.add(expeditionsResponse);
    }
  }

  if(track['trackPoints'] != null){
    if(track['trackPoints'] is List && track['trackPoints'].isNotEmpty){
      for(var address in track['trackPoints']){
        AddressModel addr = AddressModel(address['id'],address['street'], address['civicNumber'], address['city'], address['province'], address['cap']);
        trackPoints.add(addr);
      }
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
      expeditions,
      trackPoints: trackPoints,
      actualCity: track['actualCity'] != null ? AddressModel(track['actualCity']['id'],track['actualCity']['street'], track['actualCity']['civicNumber'], track['actualCity']['city'], track['actualCity']['province'], track['actualCity']['cap']) : null
  );
  return t;
}

Future<TrackModel> trackMapperNoExpeditions(Map<String, dynamic> track)async{
  List<OwnerExModel> customers = [];
  List<LatLng> polylines = [];
  List<ExpeditionModel> expeditions = [];
  List<AddressModel> trackPoints = [];
  List<DriverEvaluation> evaluations = [];

  for(var p in track['polylines']){
    LatLng polyline = LatLng(p['lat'], p['lng']);
    polylines.add(polyline);
  }

  if(track['truckDriver']['evaluations'] != null && track['truckDriver']['evaluations'] is List && track['truckDriver']['evaluations'].isNotEmpty){
    for(var evaluation in track['truckDriver']['evaluations']){
      DriverEvaluation e = DriverEvaluation(evaluation['content'], evaluation['user'], evaluation['userImage'],double.parse(evaluation['evaluation']) );
      evaluations.add(e);
    }
  }

  TruckModel truck = TruckModel(track['truck']['id'], track['truck']['model'], track['truck']['plate'], track['truck']['truckType'], track['truck']['trailerType'],track['truck']['isAssigned']);
  OwnerExModel truckDriver = OwnerExModel(track['truckDriver']['id'], track['truckDriver']['ownerName'], track['truckDriver']['email'], track['truckDriver']['phone'], track['truckDriver']['token'], userTypeConverter(track['truckDriver']['userType']) ,track['truckDriver']['profileImage'], fiscalCode: track['truckDriver']['fiscalCode'], vatNumber: track['truckDriver']['vatNumber'], evaluations: evaluations);


  if(track['trackPoints'] != null){
    if(track['trackPoints'] is List && track['trackPoints'].isNotEmpty){
      for(var address in track['trackPoints']){
        AddressModel addr = AddressModel(address['id'],address['street'], address['civicNumber'], address['city'], address['province'], address['cap']);
        trackPoints.add(addr);
      }
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
      expeditions,
      trackPoints: trackPoints,
      actualCity: track['actualCity'] != null ? AddressModel(track['actualCity']['id'],track['actualCity']['street'], track['actualCity']['civicNumber'], track['actualCity']['city'], track['actualCity']['province'], track['actualCity']['cap']) : null
  );
  return t;
}