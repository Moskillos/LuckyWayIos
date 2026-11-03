import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/address_model.dart';
import 'package:lucky_way_ios/models/chat_model.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/truck_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';

UserType userTypeConverter(String type){
  if(type == "UserType.PHYSICPERSON"){
    return UserType.PHYSICPERSON;
  } else if(type == "UserType.GIURIDICPERSON"){
    return UserType.GIURIDICPERSON;
  } else {
    return UserType.TRUCKDRIVER;
  }
}

Future<PhysicPerson> physicPersonMapper( Map<String, dynamic> physicPerson)async{
  List<AddressModel> addresses = [];
  List<ExpeditionModel> expeditions = [];
  List<TrackModel> tracks = [];
  List<UserType> types = [];

  if(physicPerson['addresses'] is List && physicPerson['addresses'].isNotEmpty){
    for(var address in physicPerson['addresses']){

      AddressModel addr = AddressModel(address['id'],address['street'], address['civicNumber'], address['city'], address['province'], address['cap']);
      addresses.add(addr);
    }
  }
  if(physicPerson['expeditions'] is List && physicPerson['expeditions'].isNotEmpty){
    for(var expedition in physicPerson['expeditions']){
      ExpeditionModel expeditionResponse = await FirebaseDatabase().getExpedition(expedition, null);
      expeditions.add(expeditionResponse);
    }

  }

  if(physicPerson['tracks'] is List && physicPerson['tracks'].isNotEmpty){
    for(var track in physicPerson['tracks']){
      TrackModel trackResponse = await FirebaseDatabase().getTrack(track);
      tracks.add(trackResponse);
    }
  }

  for(var type in physicPerson['userType']){
    types.add(userTypeConverter(type));
  }

  return PhysicPerson(physicPerson['id'], physicPerson['name'], physicPerson['lastName'], physicPerson['email'], physicPerson['phone'], physicPerson['creationDate'], physicPerson['birthDate'],physicPerson['profileImage'] ?? '',physicPerson['token'] ,types,userTypeConverter(physicPerson['userView']),tracks , physicPerson['fiscalCode'],addresses, expeditions);


}

Future<LegalPerson> legalPersonMapper( Map<String, dynamic> legalPerson)async{
  List<AddressModel> addresses = [];
  List<ExpeditionModel> expeditions = [];
  List<TrackModel> tracks = [];
  List<UserType> types = [];
  List<ChatModel> chats = [];

  if(legalPerson['addresses'] is List && legalPerson['addresses'].isNotEmpty){
    for(var address in legalPerson['addresses']){

      AddressModel addr = AddressModel(address['id'],address['street'], address['civicNumber'], address['city'], address['province'], address['cap']);
      addresses.add(addr);
    }
  }
  if(legalPerson['expeditions'] is List && legalPerson['expeditions'].isNotEmpty){
    for(var expedition in legalPerson['expeditions']){
      ExpeditionModel expeditionResponse = await FirebaseDatabase().getExpedition(expedition, null);
      expeditions.add(expeditionResponse);
    }

  }
  if(legalPerson['tracks'] is List && legalPerson['tracks'].isNotEmpty){
    for(var track in legalPerson['tracks']){
      TrackModel trackResponse = await FirebaseDatabase().getTrack(track);
      tracks.add(trackResponse);
    }
  }



  for(var type in legalPerson['userType']){
    types.add(userTypeConverter(type));
  }

  return LegalPerson(legalPerson['id'], legalPerson['name'], legalPerson['lastName'], legalPerson['email'], legalPerson['phone'], legalPerson['creationDate'], legalPerson['birthDate'],legalPerson['profileImage'] ?? '',legalPerson['token'],types, userTypeConverter(legalPerson['userView']), legalPerson['companyName'], tracks, legalPerson['vatNumber'], legalPerson['uniqueCode'] ?? '', addresses, expeditions );

}

Future<TruckDriverModel> truckDriverMapper( Map<String, dynamic> driver)async{

  List<TruckModel> trucks = [];
  List<TrackModel> tracks = [];
  List<UserType> types = [];
  List<ChatModel> chats = [];
  List<DriverEvaluation> evaluations = [];

  if(driver['trucks'] is List && driver['trucks'].isNotEmpty){
    for(var truck in driver['trucks']){
      TruckModel t = TruckModel(truck['id'], truck['model'], truck['plate'], truck['truckType'], truck['trailerType'], truck['isAssigned'] ?? false);

      trucks.add(t);
    }
  }

  for(var track in driver['tracks']){
    TrackModel tracksResponse = await FirebaseDatabase().getTrack(track);
    tracks.add(tracksResponse);
  }

  for(var type in driver['userType']){
    types.add(userTypeConverter(type));
  }

  if(driver['evaluations'] != null && driver['evaluations'] is List && driver['evaluations'].isNotEmpty){
    for(var evaluation in driver['evaluations']){
      DriverEvaluation e = DriverEvaluation(evaluation['content'], evaluation['user'], evaluation['userImage'],double.parse(evaluation['evaluation']) );
      evaluations.add(e);
    }
  }


  TruckDriverModel t = TruckDriverModel(driver['id'], driver['name'], driver['lastName'], driver['email'], driver['phone'], driver['creationDate'], driver['birthDate'], driver['profileImage'] ?? '',driver['token'],types, userTypeConverter(driver['userView']), tracks, trucks, driver['driverLicense'], driver['driverCode'], driver['vatNumber'], driver['uniqueCode'] ?? '', evaluations, driver['iban']);

  return t;

}