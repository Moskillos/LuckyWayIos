

import '../models/user_model.dart';

UserType userTypeConverter(String type){
  if(type == 'UserType.TRUCKDRIVER'){
    return UserType.TRUCKDRIVER;
  } else if(type == 'UserType.GIURIDICPERSON'){
    return UserType.GIURIDICPERSON;
  } else {
    return UserType.PHYSICPERSON;
  }
}