import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../costants/truck_typologies.dart';
import '../../models/truck_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/input/custom_input.dart';

class NewTruckScreen extends StatefulWidget {
  final List<String> truckTypes;
  const NewTruckScreen({super.key, required this.truckTypes});

  @override
  State<NewTruckScreen> createState() => _NewTruckScreenState();
}

class _NewTruckScreenState extends State<NewTruckScreen> {
  TruckType? type;
  String truckModel = '';
  String truckPlate = '';
  String trailer = '';
  bool truckName = false;
  String typeString = '';
  List<String> trailers = [];

  void setTruckPlate(String value){
    truckPlate = value;
  }

  void setTruckModel(String value){
    setState(() {
      truckModel = value;
    });
  }

  void setTrailer(String value){
    setState(() {
      trailer = value;
      truckName = true;
    });

  }

  void setType(String value){
    setState(() {
      typeString = value;
      type = truckTypeFromStringConverter(value);
    });
    print(type);
    if(type == TruckType.BISARCA){
      setState(() {
        truckName = true;
      });
    } else {
      for(var t in truckTypologies){
        if(t.truckModel == type){
          setState(() {
            trailers.addAll(t.trailerList);
          });
        }
      }
    }

  }

  Widget render(){
    if(type != null){
      if(truckName){
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckModel, label: AppLocalizations.of(context).translate("truckBrand")),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckPlate, label: AppLocalizations.of(context).translate("truckPlate"),),

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
            children: List.generate(widget.truckTypes.length, (index) => SelectorWidgetCard(border: true,setUserPurpose: setType, type: widget.truckTypes[index], image: 'assets/truck.svg', text: widget.truckTypes[index], userPurpose: typeString)),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("newTruck"),
        button: !truckName ? SizedBox() : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30,),
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
                    setState(() => truckName = false);
                    setState(() => type = null);
                    setState(() => truckPlate = '');
                    setState(() => truckModel = '');
                    setState(() => trailer = '');
                  });
                  Navigator.of(context).pop();
                })
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15),
          child: render(),
        ),
        showHeader: true,
        isNavigate: true);

  }
}
