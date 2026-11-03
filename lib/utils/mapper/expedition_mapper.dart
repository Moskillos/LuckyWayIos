import 'dart:math';

import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/utils/mapper/user_mapper.dart';

import '../../models/address_model.dart';
import '../../models/expedition_model.dart';
import '../../models/package_model.dart';
import '../../models/user_model.dart';

ExpeditionModel expeditionMapper(
    Map<String, dynamic> expedition, TrackModel? track) {
  List<PackageModel> packages = [];

  for (var pack in expedition['packages']) {
    PackageModel package = PackageModel(
        pack['name'],
        pack['width'],
        pack['length'],
        pack['height'],
        pack['weight'],
        pack['flammable'],
        pack['fragile'],
        pack['merchandise']);
    packages.add(package);
  }

  AddressModel retireAddress = AddressModel(
      expedition['retireAddress']['id'],
      expedition['retireAddress']['street'],
      expedition['retireAddress']['civicNumber'],
      expedition['retireAddress']['city'],
      expedition['retireAddress']['province'],
      expedition['retireAddress']['cap']);
  AddressModel destinationAddress = AddressModel(
      expedition['destinationAddress']['id'],
      expedition['destinationAddress']['street'],
      expedition['destinationAddress']['civicNumber'],
      expedition['destinationAddress']['city'],
      expedition['destinationAddress']['province'],
      expedition['destinationAddress']['cap']);

  OwnerExModel owner = OwnerExModel(
      expedition['owner']['id'],
      expedition['owner']['ownerName'],
      expedition['owner']['email'],
      expedition['owner']['phone'],
      expedition['owner']['token'],
      userTypeConverter(expedition['owner']['userType']),
      expedition['owner']['profileImage']
  );

  UserExpeditionType receiver = UserExpeditionType(
      expedition['receiver']['role'],
      expedition['receiver']['name'],
      expedition['receiver']['email'],
      expedition['receiver']['phone']);
  UserExpeditionType sender = UserExpeditionType(
      expedition['sender']['role'],
      expedition['sender']['name'],
      expedition['sender']['email'],
      expedition['sender']['phone']);

  ExpeditionModel expe = ExpeditionModel(
      expedition['date'],
      expedition['id'],
      packages,
      expedition['equip'],
      expedition['equipment'] ?? '',
      retireAddress,
      destinationAddress,
      expedition['offer'],
      owner,
      expedition['accepted'],
      expedition['paid'] ?? false,
      expedition['retired'] ?? false,
      expedition['completed'] ?? false,
      expedition['senderRole'],
      receiver,
      sender,
      track: track?.id,
      trackDriverId: track?.truckDriver.id
  );

  return expe;
}

Future<ExpeditionModel> expeditionMapperWithTrack(
    Map<String, dynamic> expedition) async {
  List<PackageModel> packages = [];

  for (var pack in expedition['packages']) {
    PackageModel package = PackageModel(
        pack['name'],
        pack['width'],
        pack['length'],
        pack['height'],
        pack['weight'],
        pack['flammable'],
        pack['fragile'],
        pack['merchandise']);
    packages.add(package);
  }

  AddressModel retireAddress = AddressModel(
      expedition['retireAddress']['id'],
      expedition['retireAddress']['street'],
      expedition['retireAddress']['civicNumber'],
      expedition['retireAddress']['city'],
      expedition['retireAddress']['province'],
      expedition['retireAddress']['cap']);
  AddressModel destinationAddress = AddressModel(
      expedition['destinationAddress']['id'],
      expedition['destinationAddress']['street'],
      expedition['destinationAddress']['civicNumber'],
      expedition['destinationAddress']['city'],
      expedition['destinationAddress']['province'],
      expedition['destinationAddress']['cap']);

  OwnerExModel owner = OwnerExModel(
      expedition['owner']['id'],
      expedition['owner']['ownerName'],
      expedition['owner']['email'],
      expedition['owner']['phone'],
      expedition['owner']['token'],
      userTypeConverter(expedition['owner']['userType']),
      expedition['owner']['profileImage']
  );
  UserExpeditionType receiver = UserExpeditionType(
      expedition['receiver']['role'],
      expedition['receiver']['name'],
      expedition['receiver']['email'],
      expedition['receiver']['phone']);
  UserExpeditionType sender = UserExpeditionType(
      expedition['sender']['role'],
      expedition['sender']['name'],
      expedition['sender']['email'],
      expedition['sender']['phone']);
  ExpeditionModel expe = ExpeditionModel(
      expedition['date'],
      expedition['id'],
      packages,
      expedition['equip'],
      expedition['equipment'] ?? '',
      retireAddress,
      destinationAddress,
      expedition['offer'],
      owner,
      expedition['accepted'],
      expedition['paid'] ?? false,
      expedition['retired'] ?? false,
      expedition['completed'] ?? false,
      expedition['senderRole'],
      receiver,
      sender,
      track: expedition['track'],
      trackDriverId: expedition['trackDriverId']);

  return expe;
}
