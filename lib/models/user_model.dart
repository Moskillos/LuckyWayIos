import 'package:lucky_way_ios/models/address_model.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/truck_model.dart';

class DriverEvaluation{
  String content;
  String user;
  String userImage;
  double evaluation;

  DriverEvaluation(this.content, this.user, this.userImage, this.evaluation);
}

sealed class UserBase {
  String id;
  String name;
  String lastName;
  String email;
  String phone;
  String creationDate;
  String birthDate;
  String profileImage;
  String token;
  List<UserType> userType = [];
  UserType userView;

  UserBase(this.id, this.name, this.lastName, this.email, this.phone, this.creationDate, this.birthDate, this.profileImage, this.token,this.userType, this.userView);
}

enum UserType{
  TRUCKDRIVER,
  GIURIDICPERSON,
  PHYSICPERSON
}

class PhysicPerson extends UserBase {
  List<TrackModel> tracks;
  String fiscalCode;
  List<AddressModel> addresses;
  List<ExpeditionModel> expeditions;

  PhysicPerson(super.id,super.name, super.lastName,super.email, super.phone, super.creationDate, super.birthDate, super.profileImage, super.token, super.userType, super.userView, this.tracks, this.fiscalCode, this.addresses, this.expeditions);

}

class LegalPerson extends UserBase {
  String companyName;
  List<TrackModel> tracks;
  String vatNumber;
  String uniqueCode;
  List<AddressModel> addresses;
  List<ExpeditionModel> expeditions;

  LegalPerson(super.id, super.name, super.lastName,super.email, super.phone, super.creationDate, super.birthDate,super.profileImage, super.token,super.userType, super.userView,this.companyName, this.tracks, this.vatNumber,this.uniqueCode, this.addresses, this.expeditions);

}

class TruckDriverModel extends UserBase{
  List<TrackModel> tracks;
  List<TruckModel> trucks;
  String driverLicense;
  String driverCode;
  String uniqueCode;
  String vatNumber;
  List<DriverEvaluation> evaluations;
  String iban;

  TruckDriverModel(
      super.id,
      super.name,
      super.lastName,
      super.email,
      super.phone,
      super.creationDate,
      super.birthDate,
      super.profileImage,
      super.token,
      super.userType,
      super.userView,
      this.tracks,
      this.trucks,
      this.driverLicense,
      this.driverCode,
      this.uniqueCode,
      this.vatNumber,
      this.evaluations,
      this.iban
      );
}
