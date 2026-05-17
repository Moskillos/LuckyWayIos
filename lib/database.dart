import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucky_way_ios/utils/mapper/chat_mapper.dart';
import 'package:lucky_way_ios/utils/mapper/expedition_mapper.dart';
import 'package:lucky_way_ios/utils/mapper/expeditions_mapper.dart';
import 'package:lucky_way_ios/utils/mapper/track_mapper.dart';
import 'package:lucky_way_ios/utils/mapper/tracks_mapper.dart';
import 'package:lucky_way_ios/utils/mapper/user_mapper.dart';
import 'package:lucky_way_ios/utils/track_state_converter.dart';

import 'models/address_model.dart';
import 'models/chat_model.dart';
import 'models/expedition_model.dart';
import 'models/improve_request_model.dart';
import 'models/track_model.dart';
import 'models/truck_model.dart';
import 'models/user_model.dart';

class FirebaseDatabase {
  final db = FirebaseFirestore.instance;

  //Save user functions
  // Le prime 3 funzioni salvato i tre tipi di user

  Future<void> saveTruckDriverPerson(TruckDriverModel truckDriver) async {
    final types = [];
    for (var type in truckDriver.userType) {
      types.add(type.toString());
    }
    try {
      await db.collection('truckDrivers').doc(truckDriver.id).set({
        "id": truckDriver.id,
        "name": truckDriver.name,
        "lastName": truckDriver.lastName,
        "email": truckDriver.email,
        "phone": truckDriver.phone,
        "birthDate": truckDriver.birthDate,
        "creationDate": truckDriver.creationDate,
        "userType": types,
        "token": truckDriver.token,
        "driverCode": truckDriver.driverCode,
        "driverLicense": truckDriver.driverLicense,
        "uniqueCode": truckDriver.uniqueCode,
        "vatNumber": truckDriver.vatNumber,
        "expeditions": [],
        "tracks": [],
        "trucks": [],
        "addresses": [],
        "chats": [],
        "userView": truckDriver.userView.toString(),
        "iban": truckDriver.iban
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveLegalPerson(LegalPerson legalPerson) async {
    final types = [];
    for (var type in legalPerson.userType) {
      types.add(type.toString());
    }
    await db.collection('legalPersons').doc(legalPerson.id).set({
      "id": legalPerson.id,
      "name": legalPerson.name,
      "lastName": legalPerson.lastName,
      "email": legalPerson.email,
      "phone": legalPerson.phone,
      "birthDate": legalPerson.birthDate,
      "creationDate": legalPerson.creationDate,
      "userType": types,
      "token": legalPerson.token,
      "companyName": legalPerson.companyName,
      "vatNumber": legalPerson.vatNumber,
      "uniqueCode": legalPerson.uniqueCode,
      "expeditions": [],
      "tracks": [],
      "addresses": [],
      "chats": [],
      "userView": legalPerson.userView.toString()
    });
  }

  Future<void> savePhysicPerson(PhysicPerson physicPerson) async {
    final types = [];
    for (var type in physicPerson.userType) {
      types.add(type.toString());
    }

    await db.collection('physicPersons').doc(physicPerson.id).set({
      "id": physicPerson.id,
      "name": physicPerson.name,
      "lastName": physicPerson.lastName,
      "email": physicPerson.email,
      "phone": physicPerson.phone,
      "birthDate": physicPerson.birthDate,
      "creationDate": physicPerson.creationDate,
      "userType": types,
      "token": physicPerson.token,
      "fiscalCode": physicPerson.fiscalCode,
      "expeditions": [],
      "tracks": [],
      "addresses": [],
      "chats": [],
      "driverEvaluations": [],
      "userView": physicPerson.userView.toString()
    });
  }

  // Le prossime 3 funzioni ottengono i tre tipi diversi di user

  Future<LegalPerson> getlegalPerson(String userId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('legalPersons')
        .where('id', isEqualTo: userId)
        .get();
    List<Map<String, dynamic>> legalPerson =
        getResponse.docs.map((doc) => doc.data()).toList();
    return legalPersonMapper(legalPerson[0]);
  }

  Future<PhysicPerson> getPhysicPerson(String userId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('physicPersons')
        .where('id', isEqualTo: userId)
        .get();
    List<Map<String, dynamic>> physicPerson =
        getResponse.docs.map((doc) => doc.data()).toList();
    return physicPersonMapper(physicPerson[0]);
  }

  Future<TruckDriverModel> getTruckDriverById(String userId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('truckDrivers')
        .where('id', isEqualTo: userId)
        .get();
    List<Map<String, dynamic>> driver =
        getResponse.docs.map((doc) => doc.data()).toList();
    return truckDriverMapper(driver[0]);
  }

  // Di seguito le due funzioni per creare e aggiornare le spedizioni dell'utente

  Future<void> addNewTruck(UserBase user, TruckModel truck) async {
    final newTruck = {
      "id": truck.id,
      "trailerType": truck.trailerType,
      "truckType": truck.truckType,
      "plate": truck.plate,
      "model": truck.model,
    };

    await db.collection('truckDrivers').doc(user.id).update({
      "trucks": FieldValue.arrayUnion([newTruck])
    });
  }

  Future<void> updateTruck(UserBase user, TruckModel updatedTruck) async {
    try {
      final docRef = db.collection('truckDrivers').doc(user.id);
      final doc = await docRef.get();

      if (doc.exists) {
        List<dynamic> trucks = doc.data()?['trucks'] ?? [];

        // Modifica il truck con lo stesso id
        final updatedTrucks = trucks.map((truck) {
          if (truck['id'] == updatedTruck.id) {
            return {
              "id": updatedTruck.id,
              "plate": updatedTruck.plate,
              "model": updatedTruck.model,
              "trailerType": updatedTruck.trailerType,
              "truckType": updatedTruck.truckType,
              "isAssigned": updatedTruck.isAssigned,
            }; // Assicurati che `toJson()` restituisca una mappa
          }
          return truck;
        }).toList();

        await docRef.update({"trucks": updatedTrucks});
      }
    } catch (e) {
      rethrow;
    }
  }

  // Funzione di salvataggio indirizzo

  Future<void> saveNewAddress(UserBase user, AddressModel address) async {
    final newAddress = {
      "id": address.id,
      "street": address.street,
      "civicNumber": address.civicNumber,
      "city": address.city,
      "province": address.province,
      "cap": address.cap,
    };
    if (user is LegalPerson) {
      try {
        await db.collection('legalPersons').doc(user.id).update({
          "addresses": FieldValue.arrayUnion([newAddress])
        });
      } catch (e) {
        rethrow;
      }
    } else if (user is PhysicPerson) {
      try {
        await db.collection('physicPersons').doc((user).id).update({
          "addresses": FieldValue.arrayUnion([newAddress])
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<ExpeditionModel>> getExpeditions() async {
    QuerySnapshot<Map<String, dynamic>> getResponse =
        await db.collection('expeditions').get();

    List<Map<String, dynamic>> expeditions =
        getResponse.docs.map((doc) => doc.data()).toList();
    return expeditionsMapper(expeditions);
  }

  Future<ExpeditionModel> getExpedition(
      String expeditionId, TrackModel? track) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('expeditions')
        .where('id', isEqualTo: expeditionId)
        .get();
    List<Map<String, dynamic>> expedition =
        getResponse.docs.map((doc) => doc.data()).toList();
    return expeditionMapper(expedition[0], track);
  }

  Future<ExpeditionModel> getExpeditionWithTrack(String expeditionId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('expeditions')
        .where('id', isEqualTo: expeditionId)
        .get();
    List<Map<String, dynamic>> expedition =
        getResponse.docs.map((doc) => doc.data()).toList();
    return expeditionMapperWithTrack(expedition[0]);
  }

  Future<List<TrackModel>> getAllTracks() async {
    QuerySnapshot<Map<String, dynamic>> getResponse =
        await db.collection('tracks').get();
    List<Map<String, dynamic>> tracks =
        getResponse.docs.map((doc) => doc.data()).toList();
    return tracksMapper(tracks);
  }

  Future<TrackModel> getTrack(String trackId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse =
        await db.collection('tracks').where('id', isEqualTo: trackId).get();
    List<Map<String, dynamic>> track =
        getResponse.docs.map((doc) => doc.data()).toList();
    return trackMapper(track[0]);
  }

  Future<List<TrackModel>> getUserTracks(String truckDriverId) async {
    QuerySnapshot<Map<String, dynamic>> getResponse = await db
        .collection('tracks')
        .where('truckDriver', isEqualTo: truckDriverId)
        .get();
    List<Map<String, dynamic>> tracks =
        getResponse.docs.map((doc) => doc.data()).toList();
    return tracksMapper(tracks);
  }

  Future<void> saveTrack(TrackModel track) async {
    try {
      final customers = [];
      final expeditions = [];
      final evaluations = [];

      if (track.customers.isNotEmpty) {
        for (var customer in track.customers) {
          customers.add(customer.id);
        }
      }

      if (track.expeditions.isNotEmpty) {
        for (var expedition in track.expeditions) {
          expeditions.add(expedition.id);
        }
      }

      if (track.truckDriver.evaluations != null && track.truckDriver.evaluations!.isNotEmpty) {
        for (var evaluation in track.truckDriver.evaluations!) {
          evaluations.add({
            "content": evaluation.content,
            "user": evaluation.user,
            "userImage": evaluation.userImage,
            "evaluation": evaluation.evaluation,
          });
        }
      }

      final truck = {
        "id": track.truck.id,
        "trailerType": track.truck.trailerType,
        "truckType": track.truck.truckType,
        "plate": track.truck.plate,
        "model": track.truck.model,
        "isAssigned": true
      };

      final truckDriver = {
        "id": track.truckDriver.id,
        "ownerName": track.truckDriver.ownerName,
        "email": track.truckDriver.email,
        "phone": track.truckDriver.phone,
        "token": track.truckDriver.token,
        "userType": track.truckDriver.userType.toString(),
        "profileImage": track.truckDriver.profileImage,
        "vatNumber": track.truckDriver.vatNumber,
        "evaluations": evaluations
      };

      await db.collection('tracks').doc(track.id).set({
        "id": track.id,
        "creationDate": track.creationDate,
        "travelDate": track.travelDate,
        "travelTime": track.travelTime,
        "duration": track.duration,
        "distance": track.distance,
        "origin": track.origin,
        "destination": track.destination,
        "polylines": track.polylines
            .map((e) => {"lat": e.latitude, "lng": e.longitude})
            .toList(),
        "image": track.image,
        "slot": track.slot,
        "availableWeight": track.availableWeight,
        "availableLength": track.availableLength,
        "truck": truck,
        "truckDriver": truckDriver,
        "customers": customers,
        "trackState": trackStateEnumConverter(track.trackState),
        "merchandise": track.merchandise,
        "expeditions": expeditions
      });
    } catch (e) {
      if (e is FirebaseException) {
        rethrow;
      }
      rethrow;
    }
  }

  Future<void> saveUserTrack(
      TrackModel track, TruckDriverModel user, String truckId) async {
    try {
      // Recupera il documento dell'autista
      DocumentSnapshot truckDriverSnapshot =
          await db.collection('truckDrivers').doc(user.id).get();

      if (!truckDriverSnapshot.exists) {
        return;
      }

      // Converti il documento in una mappa
      Map<String, dynamic> truckDriverData =
          truckDriverSnapshot.data() as Map<String, dynamic>;

      // Recupera la lista dei camion
      List<dynamic> trucks = truckDriverData["trucks"] ?? [];

      // Cerca il truck con l'ID corrispondente
      int truckIndex = trucks.indexWhere((truck) => truck["id"] == truckId);

      if (truckIndex == -1) {
        return;
      }

      // Modifica il truck per impostare isAssigned a true
      trucks[truckIndex]["isAssigned"] = true;

      // Aggiorna il documento con il nuovo array trucks e aggiunge la track
      await db.collection('truckDrivers').doc(user.id).update({
        "tracks": FieldValue.arrayUnion([track.id]),
        "trucks": trucks, // Salva il nuovo stato dei camion
      });
    } catch (e) {
      rethrow;
    }
  }

  // Funzioni di salvataggio spedizioni

  Future<void> saveExpedition(ExpeditionModel expedition) async {
    try {
      final packages = [];

      if (expedition.packages.isNotEmpty) {
        for (var package in expedition.packages) {
          final pack = {
            "name": package.name,
            "length": package.length,
            "width": package.width,
            "height": package.height,
            "weight": package.weight,
            "flammable": package.flammable,
            "fragile": package.fragile,
            "merchandise": package.merchandise,
          };

          packages.add(pack);
        }
      }
      await db.collection('expeditions').doc(expedition.id).set({
        "id": expedition.id,
        "packages": packages,
        "equip": expedition.equip,
        "equipment": expedition.equipment,
        "retireAddress": {
          "id": expedition.retireAddress.id,
          "street": expedition.retireAddress.street,
          "civicNumber": expedition.retireAddress.civicNumber,
          "city": expedition.retireAddress.city,
          "province": expedition.retireAddress.province,
          "cap": expedition.retireAddress.cap,
        },
        "destinationAddress": {
          "id": expedition.destinationAddress.id,
          "street": expedition.destinationAddress.street,
          "civicNumber": expedition.destinationAddress.civicNumber,
          "city": expedition.destinationAddress.city,
          "province": expedition.destinationAddress.province,
          "cap": expedition.destinationAddress.cap,
        },
        "offer": expedition.offer,
        "owner": {
          "id": expedition.owner.id,
          "ownerName": expedition.owner.ownerName,
          "email": expedition.owner.email,
          "phone": expedition.owner.phone,
          "token": expedition.owner.token,
          "userType": expedition.owner.userType.toString(),
          "profileImage": expedition.owner.profileImage,
          "fiscalCode": expedition.owner.fiscalCode,
          "vatNumber": expedition.owner.vatNumber
        },
        "senderRole": expedition.senderRole,
        "receiver": {
          "name": expedition.receiver.name,
          "email": expedition.receiver.email,
          "role": expedition.receiver.role,
          "phone": expedition.receiver.phone,
        },
        "sender": {
          "name": expedition.sender.name,
          "email": expedition.sender.email,
          "role": expedition.sender.role,
          "phone": expedition.sender.phone,
        },
        "accepted": expedition.accepted,
        "retired": expedition.retired,
        "completed": expedition.completed,
        "paid": expedition.paid
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> savelegalPersonExpedition(
      String userId, String expeditionId) async {
    await db.collection('legalPersons').doc(userId).update({
      "expeditions": FieldValue.arrayUnion([expeditionId])
    });
  }

  Future<void> savePhysicPersonExpedition(
      String userId, String expeditionId) async {
    await db.collection('physicPersons').doc(userId).update({
      "expeditions": FieldValue.arrayUnion([expeditionId])
    });
  }

  Future<void> changeAcceptationOnDb(
      ExpeditionModel expedition, TrackModel track) async {
    await db.collection('expeditions').doc(expedition.id).update({
      "accepted": true,
    });

    await db
        .collection('expeditions')
        .doc(expedition.id)
        .set({"track": track.id});
  }

  Future<void> addNewExpeditionToTrack(
      String trackId, ExpeditionModel expedition) async {
    try {
      await db.collection('tracks').doc(trackId).update({
        "expeditions": FieldValue.arrayUnion([expedition.id])
      });
      await db
          .collection('expeditions')
          .doc(expedition.id)
          .update({"track": trackId, "accepted": true});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpedition(
      String userId, String expeditionId, isLegalPerson) async {
    try {
      await db.collection('expeditions').doc(expeditionId).delete();
      if (isLegalPerson) {
        await db.collection('legalPersons').doc(userId).update({
          'expeditions': FieldValue.arrayRemove([expeditionId])
        });
      } else {
        await db.collection('physicPersons').doc(userId).update({
          'expeditions': FieldValue.arrayRemove([expeditionId])
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> savePhysicPersonImage(String userId, String image) async {
    try {
      await db
          .collection('physicPersons')
          .doc(userId)
          .update({'profileImage': image});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLegalPersonImage(String userId, String image) async {
    try {
      await db
          .collection('legalPersons')
          .doc(userId)
          .update({'profileImage': image});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTruckDriverImage(String userId, String image) async {
    try {
      await db
          .collection('truckDrivers')
          .doc(userId)
          .update({'profileImage': image});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTruck(String userId, String truckId) async {
    try {
      // Ottieni l'array trucks dall'utente
      DocumentSnapshot userDoc =
          await db.collection('truckDrivers').doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> trucks =
            (userDoc.data() as Map<String, dynamic>)['trucks'] ?? [];

        // Filtra l'array rimuovendo il truck con l'ID corrispondente
        List<dynamic> updatedTrucks = trucks.where((truck) {
          return truck['id'] !=
              truckId; // Mantieni solo i truck che non hanno l'ID da eliminare
        }).toList();

        // Aggiorna il documento con il nuovo array
        await db.collection('truckDrivers').doc(userId).update({
          'trucks': updatedTrucks,
        });
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> getChat(String chatId) async {
    DocumentSnapshot chatDoc =
    await db.collection('chats').doc(chatId).get();
    return chatMapper(chatDoc.data() as Map<String, dynamic>);
  }

  Future<void> setTrackState(String trackId, TrackStates trackState) async {
    try {
      await db
          .collection('tracks')
          .doc(trackId)
          .update({"trackState": trackState.toString()});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateExpeditionOffer(String expeditionId, int offer) async {
    try {
      await db
          .collection('expeditions')
          .doc(expeditionId)
          .update({"offer": offer});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpeditionOnTrack(String expeditionId) async {
    final CollectionReference<Map<String, dynamic>> tracksCollection =
        db.collection('tracks');
    try {
      // Trova tutti i documenti che contengono l'expeditionId nell'array expeditions
      QuerySnapshot querySnapshot = await tracksCollection
          .where("expeditions", arrayContains: expeditionId)
          .get();

      // Itera sui documenti trovati e rimuove l'expeditionId dall'array
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          "expeditions": FieldValue.arrayRemove([expeditionId])
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setNotificationToRead(String notificationId) async {
    try {
      await db
          .collection('notifications')
          .doc(notificationId)
          .update({"read": true});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onTheWayTrack(TrackModel track) async {
    final trackRef = db.collection('tracks').doc(track.id);

    // Recupera tutte le spedizioni associate al track
    final updatedExpeditions = <String>[]; // Solo quelle pagate

    await Future.wait(track.expeditions.map((expedition) async {
      final docRef = db.collection('expeditions').doc(expedition.id);
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data();
        final bool isPaid = data?['paid'] == true;

        if (isPaid) {
          updatedExpeditions.add(expedition.id);
        } else {
          // Se non è pagata, aggiorniamo `accepted` a false
          await docRef.update({'accepted': false});
        }
      }
    }));

    // Aggiorna il track rimuovendo quelle non pagate
    await trackRef.update({
      "trackState": trackStateEnumConverter(TrackStates.ONTHEWAY),
      "expeditions": updatedExpeditions
    });
  }

  Future<void> startTrack(String trackId) async {
    await db
        .collection('tracks')
        .doc(trackId)
        .update({"trackState": trackStateEnumConverter(TrackStates.STARTED)});
  }

  Future<void> setExpeditionPaid(
      String expeditionId, UserBase user, String? driverId) async {
    final batch = db.batch();

    // Aggiorna lo stato dell'expedition
    batch
        .update(db.collection('expeditions').doc(expeditionId), {"paid": true});

    if (user is LegalPerson) {
      batch.update(db.collection('legalPersons').doc(user.id), {
        "lastUpdated":
            FieldValue.serverTimestamp() // Indica che c'è stata una modifica
      });
    } else {
      batch.update(db.collection('physicPersons').doc(user.id), {
        "lastUpdated":
            FieldValue.serverTimestamp() // Indica che c'è stata una modifica
      });
    }
    if (driverId != null) {
      batch.update(db.collection('truckDrivers').doc(driverId), {
        "lastUpdated":
            FieldValue.serverTimestamp() // Indica che c'è stata una modifica
      });
    }

    await batch.commit();
  }

  Future<void> saveTrackPoints(
      String trackId, List<AddressModel> trackPoints) async {
    final points = [];

    for (var address in trackPoints) {
      points.add({
        "id": address.id,
        "street": address.street,
        "civicNumber": address.civicNumber,
        "city": address.city,
        "province": address.province,
        "cap": address.cap,
      });
    }

    await db
        .collection('tracks')
        .doc(trackId)
        .update({"trackPoints": points, "actualCity": points[0]});
  }

  Future<void> onDepartureTrack(TrackModel track) async {
    final trackRef = db.collection('tracks').doc(track.id);
    final batch = db.batch();

    // Aggiorna il track rimuovendo quelle non pagate
    await trackRef.update({
      "trackState": trackStateEnumConverter(TrackStates.STARTED),
    });

    for (var expedition in track.expeditions) {
      if (expedition.owner.userType == UserType.GIURIDICPERSON) {
        batch.update(
            db.collection('legalPersons').doc(expedition.owner.id), {
          "lastUpdated":
              FieldValue.serverTimestamp() // Indica che c'è stata una modifica
        });
      } else if (expedition.owner.userType == UserType.PHYSICPERSON) {
        batch.update(
            db.collection('physicPersons').doc(expedition.owner.id), {
          "lastUpdated":
              FieldValue.serverTimestamp() // Indica che c'è stata una modifica
        });
      }
    }
    await batch.commit();
  }

  Future<void> setActualCity(TrackModel track, AddressModel address) async {
    final batch = db.batch();
    final trackRef = db.collection('tracks').doc(track.id);

    try {
      await trackRef.update({
        "actualCity": {
          "id": address.id,
          "city": address.city,
          "street": address.street,
          "civicNumber": address.civicNumber,
          "cap": address.cap,
          "province": address.province,
        },
      });

      for (var expedition in track.expeditions) {
        if (expedition.owner.userType == UserType.GIURIDICPERSON) {
          batch.update(
              db.collection('legalPersons').doc(expedition.owner.id), {
            "lastUpdated": FieldValue
                .serverTimestamp() // Indica che c'è stata una modifica
          });
        } else if (expedition.owner.userType == UserType.PHYSICPERSON) {
          batch.update(
              db.collection('physicPersons').doc(expedition.owner.id), {
            "lastUpdated": FieldValue
                .serverTimestamp() // Indica che c'è stata una modifica
          });
        }
      }
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setExpeditionToComplete(ExpeditionModel expedition) async {
    final batch = db.batch();
    try {
      await db
          .collection('expeditions')
          .doc(expedition.id)
          .update({'completed': true});
      if (expedition.owner.userType == UserType.GIURIDICPERSON) {
        batch.update(
            db.collection('legalPersons').doc(expedition.owner.id), {
          "lastUpdated":
              FieldValue.serverTimestamp() // Indica che c'è stata una modifica
        });
      } else if (expedition.owner.userType == UserType.PHYSICPERSON) {
        batch.update(
            db.collection('physicPersons').doc(expedition.owner.id), {
          "lastUpdated":
              FieldValue.serverTimestamp() // Indica che c'è stata una modifica
        });
      }
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setTrackToComplete(TrackModel track) async {
    try {
      await db.collection('tracks').doc(track.id).update({
        "trackState": trackStateEnumConverter(TrackStates.COMPLETED),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveImproveRequest(ImproveRequestModel request) async {
    try {
      await db.collection('improveRequests').doc(request.id).set({
        "id": request.id,
        "message": request.message,
        "type": request.type,
        "userId": request.userId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDriver(TruckDriverModel user) async {
    try {
      await db.collection('truckDrivers').doc(user.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLegalPerson(LegalPerson user) async {
    try {
      await db.collection('legalPersons').doc(user.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePhysicPerson(PhysicPerson user) async {
    try {
      await db.collection('physicPersons').doc(user.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTrack(TrackModel track) async {
    try {
      await db.collection('tracks').doc(track.id).delete();

      await db.collection('truckDrivers').doc(track.truckDriver.id).update({
        'tracks': FieldValue.arrayRemove([track.id])
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createChat(ChatModel chat) async {
    final participants = [];
    final messages = [];

    if(chat.participants.isNotEmpty){
      for(var participant in chat.participants){
        participants.add({
          "id":participant.id,
          "fullName": participant.fullName,
          "profileImage": participant.profileImage,
          "userType": participant.userType.toString()
        });
      }
    }



    if(chat.messages.isNotEmpty){
      for(var message in chat.messages){
        messages.add({
          "id": message.id,
          "senderId": message.senderId,
          "read": message.read,
          "timestamp": message.timeStamp,
          "content": message.content,
          "answered": message.answered,
          "track": message.track,
          "offer": message.offer,
          "expedition": message.expedition
        });
      }
    }

    await db.collection('chats').doc(chat.id).set({
      "id": chat.id,
      'participants': participants,
      'lastMessage': chat.lastMessage,
      'timestamp': chat.timeStamp,
      "messages": messages
    });
  }

  Future<void> updateChat(String chatId,ChatMessage message)async{
    final newMessage = {
      "id": message.id,
      "senderId": message.senderId,
      "read": message.read,
      "timestamp": message.timeStamp,
      "content": message.content,
      "answered": message.answered,
      "track": message.track,
      "offer": message.offer,
      "expedition": message.expedition
    };

    await db.collection('chats').doc(chatId).update({
      "messages": FieldValue.arrayUnion([newMessage])
    });
  }

  Future<void> saveDriverChat(String userId,String chatId)async{
    await db.collection('truckDrivers').doc(userId).update({
      "chats": FieldValue.arrayUnion([chatId])
    });
  }

  Future<void> saveLegalPersonChat(String userId,String chatId)async{
    await db.collection('legalPersons').doc(userId).update({
      "chats": FieldValue.arrayUnion([chatId])
    });
  }

  Future<void> savePhysicPersonChat(String userId,String chatId)async{
    await db.collection('physicPersons').doc(userId).update({
      "chats": FieldValue.arrayUnion([chatId])
    });
  }

  Future<void> changeDriverName(TruckDriverModel user)async{
    try {
      await db.collection('truckDrivers').doc(user.id).update({
        "name": user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePhysicPersonName(UserBase user)async{
    try {
      await db.collection('physicPersons').doc(user.id).update({
        "name": user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeLegalPersonName(UserBase user)async{
    try {
      await db.collection('legalPersons').doc(user.id).update({
        "name": user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeDriverLastName(TruckDriverModel user)async{
    try {
      await db.collection('truckDrivers').doc(user.id).update({
        "lastName": user.lastName,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePhysicPersonLastName(UserBase user)async{
    try {
      await db.collection('physicPersons').doc(user.id).update({
        "lastName": user.lastName,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeLegalPersonLastName(UserBase user)async{
    try {
      await db.collection('legalPersons').doc(user.id).update({
        "lastName": user.lastName,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeDriverPhone(TruckDriverModel user)async{
    try {
      await db.collection('truckDrivers').doc(user.id).update({
        "phone": user.phone,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePhysicPersonPhone(UserBase user)async{
    try {
      await db.collection('physicPersons').doc(user.id).update({
        "phone": user.phone,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeLegalPersonPhone(UserBase user)async{
    try {
      await db.collection('legalPersons').doc(user.id).update({
        "phone": user.phone,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setExpeditionToRetired(String expeditionId)async {
    final batch = db.batch();

    // Aggiorna lo stato dell'expedition
    batch
        .update(db.collection('expeditions').doc(expeditionId), {"retired": true});
  }

  Future<void> setMessageAnswered(String chatId, String messageId)async{
    final chatRef = FirebaseFirestore.instance.collection("chats").doc(chatId);

    final snapshot = await chatRef.get();
    if (!snapshot.exists) return;

    // prendo l'array dei messaggi
    List messages = snapshot.data()?['messages'] ?? [];

    // modifico il messaggio specifico
    for (var i = 0; i < messages.length; i++) {
      if (messages[i]['id'] == messageId) {
        messages[i]['answered'] = true; // o qualsiasi campo ti serve
        break;
      }
    }

    // aggiorno l'array intero
    await chatRef.update({
      'messages': messages,
    });
  }
}
