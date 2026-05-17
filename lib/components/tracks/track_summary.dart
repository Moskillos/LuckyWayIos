import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/truck_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../utils/date_format.dart';

class TrackSummary extends StatefulWidget {
  final String selectedCity;
  final String selectedStreet;
  final String selectedNumber;
  final String selectedPostalCode;
  final String selectedProvince;
  // indirizzo di destinazione
  final String selectedDestinationCity;
  final String selectedDestinationStreet;
  final String selectedDestinationNumber;
  final String selectedDestinationPostalCode;
  final String selectedDestinationProvince;
  TruckModel? truckSelected;
  String? departureTime;
  String? arriveTime;
  String? image;
  final Function changePage;

  TrackSummary(
      {
        super.key,
        required this.selectedCity,
        required this.selectedStreet,
        required this.selectedNumber,
        required this.selectedPostalCode,
        required this.selectedProvince,
        required this.selectedDestinationCity,
        required this.selectedDestinationStreet,
        required this.selectedDestinationNumber,
        required this.selectedDestinationPostalCode,
        required this.selectedDestinationProvince,
        this.truckSelected,
        this.departureTime,
        this.arriveTime,
        this.image,
        required this.changePage
      });

  @override
  State<TrackSummary> createState() => _TrackSummaryState();
}

class _TrackSummaryState extends State<TrackSummary> {
  @override
  Widget build(BuildContext context) {
    TruckDriverModel driver = Provider.of<AppState>(context).user as TruckDriverModel;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 30),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: primaryBlue, width: 1),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate("date"),
                      style: blackText14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      dateFormat(DateTime.now()),
                      style: blackText14w700,
                    )
                  ],
                ),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).translate("track"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('${widget.selectedCity} - ${widget.selectedDestinationCity}',
                      style: blackText14w700),
                ]),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).translate("driver"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('${driver.name} ${driver.lastName}', style: blackText14w700),
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).translate("truckTypology"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.truckSelected != null ? widget.truckSelected!.truckType : '', style: blackText14w700),
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).translate("leavingTime2"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.departureTime ?? '', style: blackText14w700),
                ]),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).translate("expectedArriveTime"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.arriveTime ?? '', style: blackText14w700),
                ]),
                SizedBox(
                  height: 10,
                ),
                widget.image == null ? CircularProgressIndicator() : Image.network(widget.image!, scale: 1,),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LuckywayBtn(text: AppLocalizations.of(context).translate("publishTrack"), backgroundColor: Colors.black, icon: 'assets/send.svg', textStyle: whiteText14w700, onPressed: widget.changePage)
                  ],
                )
              ],
            )),
      ),
    );
  }
}
