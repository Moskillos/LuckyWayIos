import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/address_model.dart';
import 'package:lucky_way_ios/models/chat_model.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';

import '../models/track_model.dart';
import '../models/truck_model.dart';
import '../models/user_model.dart';

LegalPerson companyUser = LegalPerson(
    's45v444cc3ss',
    'Nome',
    'lastName',
    'Compagnia',
    '',
    '',
    'creationDate',
    'birthDate',
    '',
    [],
    UserType.PHYSICPERSON,
    '',
    [],
    'ASDAD',
    '',
    [],
    []);
PhysicPerson privateUser = PhysicPerson(
    '22eww2e',
    'Nome',
    'lastName',
    '',
    '',
    'creationDate',
    'birthDate',
    '',
    '',
    [],
    UserType.GIURIDICPERSON,
    [],
    'ASDAD',
    [],
    []);
TruckDriverModel truckDriverMock = TruckDriverModel(
    'vxxxxss',
    'name',
    'lastName',
    'email',
    'phone',
    'creationDate',
    'birthDate',
    '',
    '',
    [],
    UserType.TRUCKDRIVER,
    [],
    [],
    'driverLicense',
    'driverCode',
    'vatCode',
    '',
    [],
    '');

class AppState extends ChangeNotifier {
  UserBase user = truckDriverMock;
  List<TrackModel> tracks = [];
  List<ExpeditionModel> expeditions = [];
  bool logged = false;
  String tokenDevice = '';
  List<LatLng> polylines = [];

  void setToken(String token) {
    tokenDevice = token;
    notifyListeners();
  }

  void setPolylines(List<LatLng> polylinesSelected) {
    polylines = polylinesSelected;
    notifyListeners();
  }

  void setTruckAssigned(TruckModel truck) {
    if (user is TruckDriverModel) {
      for (var t in (user as TruckDriverModel).trucks) {
        if (t.id == truck.id) {
          t.isAssigned = true;
        }
      }
    }
    notifyListeners();
  }

  void addTrack(TrackModel newTrack, context) async {
    TrackModel track = newTrack;
    tracks.add(track);
    if (user is TruckDriverModel) {
      (user as TruckDriverModel).tracks.add(newTrack);
      await FirebaseDatabase()
          .saveUserTrack(track, (user as TruckDriverModel), track.truck.id);
    }
    try {
      await FirebaseDatabase().saveTrack(track);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void logIn() {
    if (logged) return;
    logged = true;
    notifyListeners();
  }

  void logOut() {
    if (!logged) return;
    logged = false;
    notifyListeners();
  }

  void fetchPhysicPerson(PhysicPerson physicPerson) async {
    user = physicPerson;
  }

  void fetchLegalPerson(LegalPerson legalPerson) async {
    user = legalPerson;
  }

  void fetchTruckDriver(TruckDriverModel truckDriver) async {
    user = truckDriver;
  }

  void fetchPhysicPersonPropagate(PhysicPerson physicPerson) async {
    user = physicPerson;
    notifyListeners();
  }

  void fetchLegalPersonPropagate(LegalPerson legalPerson) async {
    user = legalPerson;
    notifyListeners();
  }

  void fetchTruckDriverPropagate(TruckDriverModel truckDriver) async {
    user = truckDriver;
    notifyListeners();
  }

  void setPrivateUser(PhysicPerson physicPerson) async {
    user = physicPerson;
    try {
      await FirebaseDatabase().savePhysicPerson(physicPerson);
    } catch (e) {
      print(e);
    }
  }

  void setCompanyUser(LegalPerson legalPerson) async {
    user = legalPerson;
    try {
      await FirebaseDatabase().saveLegalPerson(legalPerson);
    } catch (e) {
      print(e);
    }
  }

  void setDriverUser(TruckDriverModel truckDriver) async {
    user = truckDriver;
    try {
      await FirebaseDatabase().saveTruckDriverPerson(truckDriver);
    } catch (e) {
      print(e);
    }
  }

  void addNewTruck(TruckModel truck) async {
    if (user is TruckDriverModel) {
      (user as TruckDriverModel).trucks.add(truck);
    }
    await FirebaseDatabase().addNewTruck(user, truck);
    notifyListeners();
  }

  void updateTruck(TruckModel truck) async {
    if (user is TruckDriverModel) {
      for (var t in (user as TruckDriverModel).trucks) {
        if (t.id == truck.id) {
          t = truck;
        }
      }
    }
    notifyListeners();
    await FirebaseDatabase().updateTruck(user, truck);

  }

  void addNewExpedition(ExpeditionModel expedition) async {
    expeditions.add(expedition);
    if (user is LegalPerson) {
      (user as LegalPerson).expeditions.add(expedition);
      await FirebaseDatabase()
          .savelegalPersonExpedition(user.id, expedition.id);
    } else if (user is PhysicPerson) {
      (user as PhysicPerson).expeditions.add(expedition);
      await FirebaseDatabase()
          .savePhysicPersonExpedition(user.id, expedition.id);
    }

    try {
      await FirebaseDatabase().saveExpedition(expedition);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void addNewAddress(AddressModel address) async {
    if (user is LegalPerson) {
      (user as LegalPerson).addresses.add(address);
    } else if (user is PhysicPerson) {
      (user as PhysicPerson).addresses.add(address);
    }
    try {
      await FirebaseDatabase().saveNewAddress(user!, address);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void fetchExpeditions(List<ExpeditionModel> newExpeditions) {
    expeditions = newExpeditions;
    notifyListeners();
  }

  void fetchTracks(List<TrackModel> newTracks) {
    tracks = newTracks;
    notifyListeners();
  }

  Future<void> addExpeditionToTrack(
      TrackModel track, ExpeditionModel expedition) async {
    for (var ex in expeditions) {
      if (ex.id == expedition.id) {
        ex.accepted = true;
      }
    }
    for (var t in tracks) {
      if (t.id == track.id) {
        t.expeditions.add(expedition);
      }
    }
    notifyListeners();
    try {
      await FirebaseDatabase().addNewExpeditionToTrack(track.id, expedition);
    } catch (e) {
      print(e);
    }
  }

  void deleteExpedition(ExpeditionModel expedition) async {
    expeditions.remove(expedition);
    if (user is LegalPerson) {
      (user as LegalPerson).expeditions.remove(expedition);
      try {
        await FirebaseDatabase().deleteExpedition(user.id, expedition.id, true);
      } catch (e) {
        print(e);
      }
    } else if (user is PhysicPerson) {
      (user as PhysicPerson).expeditions.remove(expedition);
      try {
        await FirebaseDatabase()
            .deleteExpedition(user.id, expedition.id, false);
      } catch (e) {
        print(e);
      }
    }

    notifyListeners();
  }

  void saveUserImage(String image) async {
    if (user is LegalPerson) {
      (user as LegalPerson).profileImage = image;
      try {
        await FirebaseDatabase().saveLegalPersonImage(user.id, image);
      } catch (e) {
        print(e);
      }
    } else if (user is PhysicPerson) {
      (user as PhysicPerson).profileImage = image;
      try {
        await FirebaseDatabase().savePhysicPersonImage(user.id, image);
      } catch (e) {
        print(e);
      }
    } else if (user is TruckDriverModel) {
      (user as TruckDriverModel).profileImage = image;
      try {
        await FirebaseDatabase().saveTruckDriverImage(user.id, image);
      } catch (e) {
        print(e);
      }
    }

    notifyListeners();
  }

  void deleteTruck(TruckModel truck) async {
    if (user is TruckDriverModel) {
      (user as TruckDriverModel).trucks.remove(truck);
    }
    try {
      await FirebaseDatabase().deleteTruck(user.id, truck.id);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void setTrackState(TrackModel trackModel, TrackStates trackState) async {
    for (var track in (user as TruckDriverModel).tracks) {
      if (track.id == trackModel.id) {
        track.trackState = trackState;
      }
    }
    for (var track in tracks) {
      if (track.id == trackModel.id) {
        track.trackState = trackState;
      }
    }
    notifyListeners();
    try {
      await FirebaseDatabase().setTrackState(trackModel.id, trackState);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateExpeditionOffer(
      ExpeditionModel expedition, int offer) async {
    for (var e in expeditions) {
      if (e.id == expedition.id) {
        e.offer = offer;
      }
    }

    if (user is LegalPerson) {
      for (var e in (user as LegalPerson).expeditions) {
        if (e.id == expedition.id) {
          e.offer = offer;
        }
      }
    } else if (user is PhysicPerson) {
      for (var e in (user as PhysicPerson).expeditions) {
        if (e.id == expedition.id) {
          e.offer = offer;
        }
      }
    }

    notifyListeners();

    try {
      await FirebaseDatabase().updateExpeditionOffer(expedition.id, offer);
    } catch (e) {
      print(e);
    }
  }

  void deleteTrack(TrackModel track) async {
    tracks.remove(track);
    (user as TruckDriverModel).tracks.remove(track);
    try {
      await FirebaseDatabase().deleteTrack(track);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void deleteExpeditionFromTrack(TrackModel track, ExpeditionModel expedition) async {
    tracks.remove(track);
    (user as TruckDriverModel).tracks.remove(track);
    try {
      await FirebaseDatabase().deleteTrack(track);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> changeName(String newName) async {
    user.name = newName;
    notifyListeners();
    try {
      if (user is TruckDriverModel) {
        await FirebaseDatabase().changeDriverName(user as TruckDriverModel);
      } else if (user is LegalPerson) {
        await FirebaseDatabase().changeLegalPersonName(user);
      } else {
        await FirebaseDatabase().changePhysicPersonName(user);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeLastName(String newLastName) async {
    user.lastName = newLastName;
    notifyListeners();
    try {
      if (user is TruckDriverModel) {
        await FirebaseDatabase().changeDriverLastName(user as TruckDriverModel);
      } else if (user is LegalPerson) {
        await FirebaseDatabase().changeLegalPersonLastName(user);
      } else {
        await FirebaseDatabase().changePhysicPersonLastName(user);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> changePhone(String newPhone) async {
    user.phone = newPhone;
    notifyListeners();
    try {
      if (user is TruckDriverModel) {
        await FirebaseDatabase().changeDriverPhone(user as TruckDriverModel);
      } else if (user is LegalPerson) {
        await FirebaseDatabase().changeLegalPersonPhone(user);
      } else {
        await FirebaseDatabase().changePhysicPersonPhone(user);
      }
    } catch (e) {
      print(e);
    }
  }

}
