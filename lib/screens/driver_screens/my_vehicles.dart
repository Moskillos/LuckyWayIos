import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/truck_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/driver_screens/new_truck_screen.dart';
import 'package:lucky_way_ios/screens/driver_screens/truck_modifier.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:lucky_way_ios/ui/cards/truck_card.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../costants/truck_typologies.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/cards/selector_widget_card_2.dart';
import '../../ui/custom_divider.dart';
import '../../ui/input/custom_input.dart';
import '../../utils/mapper/user_mapper.dart';

class MyVehicles extends StatefulWidget {
  const MyVehicles({super.key});

  @override
  State<MyVehicles> createState() => _MyVehiclesState();
}

class _MyVehiclesState extends State<MyVehicles> {
  bool newTruck = false;
  String typeString = '';
  TruckType? type;
  TruckAssemble? truck;
  String trailer = '';

  bool truckName = false;
  String truckModel = '';
  String truckPlate = '';
  final CollectionReference<Map<String, dynamic>> _truckDriversCollection =
  FirebaseFirestore.instance.collection('truckDrivers');





  void setTruckSelected(TruckModel truck){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => TruckModifier(truck: truck)),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(
      String userId) {
    final userStream = _truckDriversCollection.doc(userId).snapshots();

    return userStream;
  }

  @override
  Widget build(BuildContext context) {

    TruckDriverModel driver = Provider.of<AppState>(context).user as TruckDriverModel;
    List<String> truckTypes = truckTypologies.map((TruckAssemble toElement) => truckTypeConverter(toElement.truckModel)).toList();
    void setNewTruck(){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => NewTruckScreen(truckTypes: truckTypes,)),
      );
    }
    return LuckyWayLayout(
        isNavigate: true,
        showHeader: true,
        title: AppLocalizations.of(context).translate("myVehicles"),
        content: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getUser(driver.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            if (snapshot.hasError) {
              return const SizedBox();
            }
            if (!snapshot.hasData || snapshot.data!.data()!.isEmpty) {
              return const SizedBox();
            }
            final userData = snapshot.data!.data();


            return FutureBuilder<TruckDriverModel>(
              future: truckDriverMapper(userData!),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Column(
                    children: [
                      SizedBox(height: 30,),
                      CircularProgressIndicator(),
                    ],
                  ));
                }
                if (futureSnapshot.hasError) {
                  return const Center(
                      child: Text('Errore nel caricamento delle tracce', style: greyText18,));
                }
                if (!futureSnapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context).translate("myVehiclesDesc"), style: greyText18, textAlign: TextAlign.start,),
                        SizedBox(height: 20,),
                        CustomDivider(color: primaryBlue,),
                        SelectorWidgetCard2(image: 'assets/plus.svg', actionText: AppLocalizations.of(context).translate("addAVehicle"), action: setNewTruck,),


                      ],
                    ),
                  );
                }

                TruckDriverModel driver = futureSnapshot.data!;

                List<TruckModel> trucks = driver.trucks;

                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child:  Column(
                    children: [
                      Text(AppLocalizations.of(context).translate("myVehiclesDesc"), style: greyText18, textAlign: TextAlign.start,),
                      SizedBox(height: 20,),
                      CustomDivider(color: primaryBlue,),
                      Column(
                        children: List.generate(trucks.length, (index) => truckCard(trucks[index],trucks[index].model, trucks[index].plate, setTruckSelected)),
                      ),
                      SelectorWidgetCard2(image: 'assets/plus.svg', actionText: AppLocalizations.of(context).translate("addAVehicle"), action: setNewTruck,),


                    ],
                  ),
                );
              },
            );
          },
        ) ,
        button: SizedBox());
  }
}
