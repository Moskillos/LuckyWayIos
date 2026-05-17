import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../costants/truck_typologies.dart';
import '../../models/truck_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/cards/selector_widget_card_2.dart';
import '../../ui/input/custom_input.dart';

class TruckSelection extends StatefulWidget {
  final Function setTruckSelected;
  final Function setTruckId;
  final Function changePage;
  String? truck;
  TruckModel? truckSelected;
  TruckSelection({super.key, required this.setTruckSelected, required this.setTruckId, this.truck, this.truckSelected, required this.changePage});

  @override
  State<TruckSelection> createState() => _TruckSelectionState();
}

class _TruckSelectionState extends State<TruckSelection> {
  bool newTruck = false;
  String typeString = '';
  TruckType? type;
  TruckAssemble? truck;
  String trailer = '';
  List<String> trailers = [];
  bool truckName = false;
  String truckModel = '';
  String truckPlate = '';

  void setNewTruck(){
    setState(() {
      newTruck = !newTruck;
    });
  }

  void setType(String value){
    setState(() {
      typeString = value;
      type = truckTypeFromStringConverter(value);
    });
    for(var t in truckTypologies){
      if(t.truckModel == type){
        setState(() {
          trailers.addAll(t.trailerList);
        });
      }
    }
  }

  void setTrailer(String value){
    setState(() {
      trailer = value;
      truckName = true;
    });

  }

  void setTruck(TruckAssemble truckModel){
    setState(() {
      truck = truckModel;
    });
  }

  void setTruckPlate(String value){
    truckPlate = value;
  }

  void setTruckModel(String value){
    setState(() {
      truckModel = value;
    });
  }
  
  Widget newTruckPages(List<String> truckTypes, List<String> trailers){
    if(type != null){
      if(truckName){
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 10,),
                  CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckModel, label: AppLocalizations.of(context).translate("truckBrand")),
                  SizedBox(height: 10,),
                  CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckPlate, label: AppLocalizations.of(context).translate("truckPlate"),),
                  SizedBox(height: 10,),
                ],
              ),
              Column(
                children: [
                  LuckywayBtn(
                      text: AppLocalizations.of(context).translate("saveTruck"),
                      backgroundColor: Colors.black,
                      textStyle: whiteText14w700,
                      onPressed: () {
                        var uuid = Uuid();
                        String vehicleId = 'V${uuid.v4().substring(0, 8)}';
                        TruckModel t = TruckModel(vehicleId, truckModel, truckPlate, truckTypeConverter(type!), trailer, false);
          
                        Provider.of<AppState>(context, listen: false).addNewTruck(t);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => newTruck = false);
                          setState(() => truckName = false);
                          setState(() => type = null);
                          setState(() => truckPlate = '');
                          setState(() => truckModel = '');
                          setState(() => trailer = '');
                        });
                      }),
                  SizedBox(height: 40,)
                ],
              )
          
            ],
          ),
        );
      } else {
        return Column(
          children: List.generate(trailers.length, (index) => SelectorWidgetCard(border: true,setUserPurpose: setTrailer, type: trailers[index], image: 'assets/truck.svg', text: trailers[index], userPurpose: trailer)),
        );
      }
    } else {
      return Column(
        children: [
          Text(AppLocalizations.of(context).translate("whatVehicle"), style: greyText18,),
          SizedBox(height: 40,),
          Column(
            children: List.generate(truckTypes.length, (index) => SelectorWidgetCard(border: true,setUserPurpose: setType, type: truckTypes[index], image: 'assets/truck.svg', text: truckTypes[index], userPurpose: typeString)),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TruckDriverModel user = Provider.of<AppState>(context).user as TruckDriverModel;

    List<String> truckTypes = truckTypologies.map((TruckAssemble toElement) => truckTypeConverter(toElement.truckModel)).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: newTruck ? newTruckPages(truckTypes, trailers) : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(AppLocalizations.of(context).translate("whatVehicle"), style: greyText18,),
              SizedBox(height: 40,),
              Column(
                children: List.generate(user.trucks.length, (index) => SelectorWidgetCard(border: true, setUserPurpose: widget.setTruckId, type: user.trucks[index].id, image: 'assets/truck.svg', text: '${user.trucks[index].model} - ${user.trucks[index].plate}', userPurpose: widget.truck ?? '', truckSelector: () => widget.setTruckSelected(user.trucks[index]),)),
              ),
              SelectorWidgetCard2(image: 'assets/plus.svg', actionText: AppLocalizations.of(context).translate("addAVehicle"), action: setNewTruck,),
            ],
          ),
          if(widget.truckSelected != null)Column(
            children: [
              LuckywayBtn(
                  text: AppLocalizations.of(context).translate("goOn"),
                  backgroundColor: Colors.black,
                  textStyle: whiteText14w700,
                  onPressed: () {
                    widget.changePage();
                  }),
              SizedBox(height: 40,)
            ],
          )

        ],
      ),
    );
  }
}
