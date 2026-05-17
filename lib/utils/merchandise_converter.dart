

import '../costants/merchandises.dart';
import '../models/merchandise_model.dart';

String merchandiseConverter(context,String value){
  MerchandiseModel good = merchandises(context).firstWhere((merc) => merc.value == value);

  return good.title;
}