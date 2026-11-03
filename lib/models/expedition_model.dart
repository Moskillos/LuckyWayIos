import 'package:lucky_way_ios/models/address_model.dart';
import 'package:lucky_way_ios/models/package_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';

class UserExpeditionType{
  String role;
  String name;
  String email;
  String phone;

  UserExpeditionType(this.role, this.name, this.email, this.phone);
}

class OwnerExModel{
  String ownerName;
  String email;
  String phone;
  String id;
  String token;
  UserType userType;
  String profileImage;
  String? fiscalCode;
  String? vatNumber;
  List<DriverEvaluation>? evaluations;
  OwnerExModel(this.id, this.ownerName, this.email, this.phone, this.token,this.userType, this.profileImage, {
    this.fiscalCode,
    this.vatNumber,
    this.evaluations
  });

  double driverTotalEvaluations(){
    double value = 0;

    if(evaluations != null && evaluations!.isNotEmpty){
      for(var valuation in evaluations!){
        print('valuation');
        print(valuation);
        value += valuation.evaluation;
      }
    }

    num length = evaluations != null ? evaluations!.length : 0;

    double valuation = value / length;

    if(valuation.isNaN){
      return 0;
    }
    return valuation;
  }
}

class ExpeditionModel{
  String date;
  String id;
  List<PackageModel> packages;
  bool equip;
  String equipment;
  AddressModel retireAddress;
  AddressModel destinationAddress;
  int offer;
  OwnerExModel owner;
  bool accepted;
  bool paid;
  bool retired;
  bool completed;
  String? track;
  String senderRole;
  UserExpeditionType sender;
  UserExpeditionType receiver;
  String? trackDriverId;


  ExpeditionModel(this.date,this.id, this.packages, this.equip,this.equipment, this.retireAddress, this.destinationAddress,this.offer, this.owner, this.accepted,this.paid,this.retired, this.completed,this.senderRole,this.receiver, this.sender, {
    this.track,
    this.trackDriverId
  } );

  void onAcceptation(){
    accepted = true;
  }
}