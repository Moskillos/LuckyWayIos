enum TruckType{
  FURGONE,
  AUTOCARRO,
  AUTOTRENO,
  AUTOARTICOLATO,
  BISARCA
}
class TruckAssemble{
  TruckType truckModel;
  List<String> trailerList;

  TruckAssemble(this.truckModel, this.trailerList);

}

class TruckModel{
  String id;
  String model;
  String plate;
  String truckType;
  String trailerType;
  bool isAssigned;

  TruckModel(this.id, this.model,this.plate, this.truckType, this.trailerType, this.isAssigned);


}