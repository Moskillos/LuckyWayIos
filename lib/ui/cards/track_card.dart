import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../models/expedition_model.dart';
import '../../models/track_model.dart';
import '../../models/user_model.dart';
import '../../utils/star_builder.dart';
import '../buttons/luckyway_btn.dart';
import '../buttons/luckyway_icon_btn.dart';
import '../custom_divider.dart';

class TrackCard extends StatefulWidget {
  final TrackModel track;
  final Function setSelectedTrack;
  final Function setShowExpeditions;
  TrackModel? selectedTrack;
  final bool isDriver;
  TrackCard({super.key, required this.track, required this.setSelectedTrack, required this.setShowExpeditions, required this.isDriver, this.selectedTrack});

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  LegalPerson? legalPerson;
  PhysicPerson? physicPerson;
  List<ExpeditionModel> expeditions = [];

  Future<List<ExpeditionModel>> handleExpeditions(expeditions) async {
    List<ExpeditionModel> expeditionList = [];
    for (var expedition in expeditions) {
      ExpeditionModel e = await FirebaseDatabase().getExpedition(expedition, null);
      expeditionList.add(e);
    }
    return expeditionList;
  }

  Widget stars(){
    double value = 0;

    for(var v in widget.track.truckDriver.evaluations!){
      print('v');
      print(v);
      value += v.evaluation;
    }

    double evaluation = value;

    print(evaluation);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context).translate("valuation"), style: blackText14,),
        SizedBox(width: 3,),
        buildRatingStars(widget.track.truckDriver.driverTotalEvaluations())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
          widget.setSelectedTrack(widget.track);
      },
      child: Container(
            padding: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: primaryBlue)
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!widget.isDriver)stars(),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("date"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text(widget.track.travelDate, style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("track"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text('${widget.track.origin} - ${widget.track.destination}', style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("driver"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text('${widget.track.truckDriver.ownerName}', style: blackText14w700,),
                    ],
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("trackCode"), style: blackText14,),
                      SizedBox(width: 3,),
                      Text(widget.track.id, style: blackText14w700,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  if(widget.selectedTrack != null)CustomDivider(color: Colors.black,),
                  SizedBox(height: 10,),
                  widget.selectedTrack != null ? Column(
                    children: [
                      Row(
                        children: [
                          Text(AppLocalizations.of(context).translate("truckTypology"), style: blackText14,),
                          SizedBox(width: 3,),
                          Text(widget.track.truck.truckType, style: blackText14w700,),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(AppLocalizations.of(context).translate("leavingTime"), style: blackText14,),
                          SizedBox(width: 3,),
                          Text(widget.track.travelTime, style: blackText14w700,),
                        ],
                      ),
                      Row(
                        children: [
                          Text(AppLocalizations.of(context).translate("expectedArriveTime"), style: blackText14,),
                          SizedBox(width: 3,),
                          Text(widget.track.truck.truckType, style: blackText14w700,),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.network(widget.track.image, scale: 1,),
                      SizedBox(
                        height: 20,
                      ),
                      if(widget.isDriver && widget.track.expeditions.length > 0)SizedBox(
                        height: 20,
                      ),
                      widget.isDriver ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LuckywayBtn(text: AppLocalizations.of(context).translate("handleTrack"), icon: 'assets/pencil_square.svg', backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: () async {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) => HandlerTrackScreen(track: widget.track,)),
                            // );
                          }),
                          SizedBox(width: 10,),
                          LuckywayIconBtn(onPressed: (){
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) => DeleteTrackScreen(track: widget.track,)),
                            // );
              
                          }, backgroundColor: Colors.black, icon: 'assets/delete.svg')
                        ],
                      ) : LuckywayBtn(text: AppLocalizations.of(context).translate("sendRequest"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: (){
                          widget.setShowExpeditions();
                      })
                    ],
                  ) : LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("expeditionDetails"),
                              style: blackText14w700,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  ),
                ],
              ),
            ))
    );
  }
}
