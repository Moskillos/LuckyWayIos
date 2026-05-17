

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucky_way_ios/models/truck_model.dart';

import 'address_model.dart';
import 'expedition_model.dart';

enum TrackStates{
  CREATED,
  ONTHEWAY,
  STARTED,
  COMPLETED
}

class TrackModel {
  String id;
  String creationDate;
  String travelDate;
  String travelTime;
  String duration;
  String distance;
  String origin;
  String destination;
  List<LatLng> polylines;
  String image;
  TruckModel truck;
  OwnerExModel truckDriver;
  List<OwnerExModel> customers;
  int slot;
  int availableWeight;
  int availableLength;
  TrackStates trackState;
  String merchandise;
  List<ExpeditionModel> expeditions;
  List<AddressModel>? trackPoints;
  AddressModel? actualCity;

  TrackModel(this.id, this.creationDate, this.travelDate, this.travelTime, this.duration, this.distance, this.origin, this.destination, this.polylines, this.image, this.truck, this.truckDriver, this.customers, this.slot,this.availableWeight, this.availableLength, this.trackState, this.merchandise, this.expeditions,{
    this.trackPoints,
    this.actualCity
  });

  }