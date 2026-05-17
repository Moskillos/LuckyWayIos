import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/truck_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../costants/truck_typologies.dart';
import '../../layout/lucky_way_layout.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/cards/selector_widget_card_2.dart';
import '../../ui/custom_divider.dart';
import '../../ui/input/custom_input.dart';

class TruckModifier extends StatefulWidget {
  final TruckModel truck;
  const TruckModifier({super.key, required this.truck});

  @override
  State<TruckModifier> createState() => _TruckModifierState();
}

class _TruckModifierState extends State<TruckModifier> {
  List<String> truckTypes = truckTypologies.map((TruckAssemble toElement) => truckTypeConverter(toElement.truckModel)).toList();
  String typeString = '';
  TruckType? type;
  TruckAssemble? truck;
  String trailer = '';
  List<String> trailers = [];
  bool truckName = false;
  String truckModel = '';
  String truckPlate = '';

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
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckModel, label: AppLocalizations.of(context).translate("truckBrand")),
              CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: setTruckPlate, label: AppLocalizations.of(context).translate("truckPlate"),),
              LuckywayBtn(
                  text: AppLocalizations.of(context).translate("saveTruck"),
                  backgroundColor: Colors.black,
                  textStyle: whiteText14w700,
                  onPressed: () {
                    TruckModel t = TruckModel(widget.truck.id, truckModel, truckPlate, truckTypeConverter(type!), trailer, false);
          
                    Provider.of<AppState>(context, listen: false).updateTruck(t);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() => truckName = false);
                      setState(() => type = null);
                      setState(() => truckPlate = '');
                      setState(() => truckModel = '');
                      setState(() => trailer = '');
                    });
                    Navigator.of(context).pop();
                  }),
          
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
        children: List.generate(truckTypes.length, (index) => SelectorWidgetCard(border: true,setUserPurpose: setType, type: truckTypes[index], image: 'assets/truck.svg', text: truckTypes[index], userPurpose: typeString)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        isNavigate: false,
        showHeader: false,
        title: AppLocalizations.of(context).translate("updateVehicles"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("updateVehiclesDesc"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              newTruckPages(truckTypes, trailers)
            ],
          ),
        ),
        button: SizedBox());
  }
}
