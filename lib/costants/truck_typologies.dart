import '../models/truck_model.dart';

List<TruckAssemble> truckTypologies = [
  TruckAssemble(TruckType.FURGONE, [
    'Rimorchio piccolo centinato',
    'Rimorchio pianale leggero',
    'Rimorchio cassonato',
    'Rimorchio trasporto moto',
    'Rimorchio porta auto piccolo'
  ]),
  TruckAssemble(TruckType.AUTOCARRO, [
    'Pianale con sponde',
    'Centinato',
    'Sponda idraulica',
  ]),
  TruckAssemble(TruckType.AUTOTRENO, [
    'Rimorchio pianale',
    'Rimorchio centinato',
    'Rimorchio porta auto',
  ]),
  TruckAssemble(TruckType.AUTOARTICOLATO, [
    'Semirimorchio centinato',
    'Semirimorchio pianale',
    'Semirimorchio porta auto',
  ]),
  TruckAssemble(TruckType.BISARCA, [

  ]),
];

String truckTypeConverter(TruckType type){
  if(type == TruckType.AUTOARTICOLATO){
    return 'Autoarticolato';
  } else if(type == TruckType.AUTOCARRO){
    return 'Autocarro';
  } else if(type == TruckType.AUTOTRENO){
    return 'Autotreno';
  } else if(type == TruckType.BISARCA){
    return 'Bisarca';
  } else {
    return 'Furgone';
  }
}

TruckType truckTypeFromStringConverter(String type){
  if(type == 'Autoarticolato'){
    return TruckType.AUTOARTICOLATO;
  } else if(type == 'Autocarro'){
    return TruckType.AUTOCARRO;
  } else if(type == 'Autotreno'){
    return TruckType.AUTOTRENO;
  } else if(type == 'Bisarca'){
    return TruckType.BISARCA;
  } else {
    return TruckType.FURGONE;
  }
}