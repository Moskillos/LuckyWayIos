import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../database.dart';
import '../../models/address_model.dart';
import '../../models/expedition_model.dart';
import '../../utils/show_snack_bar.dart';

class AddressDragModel{
  AddressModel address;
  String addressType;

  AddressDragModel(this.address, this.addressType);
}

class RouteSelection extends StatefulWidget {
  final String trackId;
  final List<ExpeditionModel> expeditions;
  final String origin;
  final String destination;
  const RouteSelection({super.key, required this.expeditions, required this.origin, required this.destination, required this.trackId});

  @override
  State<RouteSelection> createState() => _RouteSelectionState();
}

class _RouteSelectionState extends State<RouteSelection> {

  AnimationController? localAnimationController;
  List<AddressDragModel> availableAddresses = [];
  List<AddressDragModel?> selectedAddresses = List.filled(10, null);

  @override
  void initState() {
    super.initState();
    availableAddresses = List.from(cities());
    selectedAddresses = List.filled(cities().length + 2, null);
    selectedAddresses[0] = AddressDragModel(AddressModel('origin','', 0, widget.origin, '', 0), '');
    selectedAddresses[selectedAddresses.length -1] = AddressDragModel(AddressModel('origin','', 0, widget.destination, '', 0), '');
  }

  List<AddressDragModel> cities(){
    List<AddressDragModel> addressesString = [];
    for(var expedition in widget.expeditions){
      addressesString.add(AddressDragModel(expedition.retireAddress, 'retire') );
      addressesString.add(AddressDragModel(expedition.destinationAddress, 'destination'));
    }
     return addressesString;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(AppLocalizations.of(context).translate("insertCityInOrder")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(cities().length + 2, (index) {
                    return DragTarget<AddressDragModel>(
                      onAccept: (city) {
                        setState(() {
                          selectedAddresses[index] = city;
                          availableAddresses.remove(city); // Rimuove la città dalla lista disponibile
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if(index == 0 || index == selectedAddresses.length -1){
                                return;
                              }
                              if (selectedAddresses[index] != null) {
                                availableAddresses.add(selectedAddresses[index]!);
                                selectedAddresses[index] = null; // Svuota lo slot
                              }
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              color: selectedAddresses[index] != null
                                  ? Colors.lightBlueAccent
                                  : Colors.white,
                            ),
                            child: selectedAddresses[index] != null
                                ? Column(
                                  children: [
                                    Text(selectedAddresses[index]!.address.city,
                                        style: TextStyle(fontSize: 16)),
                                    Text(selectedAddresses[index]!.address.street,
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                )
                                : Text("Slot ${index + 1}",
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Wrap(
                direction: Axis.vertical,
                spacing: 10,
                runSpacing: 10,
                children: availableAddresses.map((address) {
                  return Draggable<AddressDragModel>(
                    data: address,
                    feedback: Material(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(address.address.city,
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                            Text(address.address.street,
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                            Text(address.address.civicNumber.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                            Text(address.addressType,
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(opacity: 0.3, child: _cityTile(address)),
                    child: _cityTile(address),
                  );
                }).toList(),
              ),
            ],
          ),
          ElevatedButton(onPressed: ()async{
            if(availableAddresses.isEmpty){
              List<AddressDragModel> validAddresses = selectedAddresses.where((address) => address != null).cast<AddressDragModel>().toList();
              List<AddressModel> mappedValidAddresses = validAddresses.map((address) => address.address).toList();

              List<AddressModel> uniqueAddresses = mappedValidAddresses.fold<Map<String, AddressModel>>(
                  {},
                      (map, address) {
                    map[address.id] = address;
                    return map;
                  }
              ).values.toList();
              await FirebaseDatabase().saveTrackPoints(widget.trackId, uniqueAddresses);
            } else {
              showErrorSnackBar(context, localAnimationController, AppLocalizations.of(context).translate("selectAllAddress"));
            }

          }, child: Text(AppLocalizations.of(context).translate("confirmTrack")))
        ],
      ),
    );
  }

  Widget _cityTile(AddressDragModel address) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(address.address.city,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(address.address.street,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(address.address.civicNumber.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(address.addressType,
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      )
    );
  }
}
