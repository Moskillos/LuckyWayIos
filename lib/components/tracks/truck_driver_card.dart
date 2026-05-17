import 'package:flutter/material.dart';
import 'package:lucky_way_ios/components/tracks/route_handler.dart';
import 'package:lucky_way_ios/components/tracks/route_selection.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../costants/track_states.dart';
import '../../database.dart';
import '../../models/address_model.dart';
import '../../models/track_model.dart';
import '../../models/user_model.dart';
import '../../utils/send_call.dart';

class TruckDriverCard extends StatefulWidget {
  final TrackModel track;
  const TruckDriverCard({super.key, required this.track});

  @override
  State<TruckDriverCard> createState() => _TruckDriverCardState();
}

class _TruckDriverCardState extends State<TruckDriverCard> {
  bool showDetails = false;
  bool isOnTheWay = false;
  String trackState = '';
  List<String> cities = [];
  int currentIndex = 0;
  List<GlobalKey> textKeys = [];
  double positionX = 0.0;
  double positionY = 0.0;
  AddressModel? selectedAddress;
  List<TrackPointSummary> trackPointSummary = [];

  @override
  void initState() {
    super.initState();
    _setSelectedAddress();
    processTrackPoints();
  }

  void _setSelectedAddress(){
    setState(() {
      selectedAddress = widget.track.actualCity;
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final states = trackStates(context);

    if (states.isNotEmpty) {
      setState(() {
        trackState = states[0].title;
      });
    }
    if(trackPointSummary.isNotEmpty && selectedAddress != null){
      int index = trackPointSummary.indexWhere((trackPoint) => trackPoint.address.id == selectedAddress!.id);
      setState(() {
        currentIndex = index;
      });
    }

  }

  Widget onTheWayStateRender() {
    if (widget.track.trackPoints != null &&
        widget.track.trackPoints!.isNotEmpty) {
      return RouteHandler(track: widget.track);
    } else {
      return RouteSelection(
          trackId: widget.track.id,
          expeditions: widget.track.expeditions,
          origin: widget.track.origin,
          destination: widget.track.destination);
    }
  }

  void processTrackPoints() {
    Map<String, TrackPointSummary> trackPointMap = {};

    for (var trackPoint in widget.track.trackPoints!) {
      if (trackPoint.id == 'origin' || trackPoint.id == 'destination') {
        trackPointMap[trackPoint.id] = TrackPointSummary(trackPoint, 'BREAKPOINT', [], 0, 0);
      } else {
        for (var expedition in widget.track.expeditions) {
          if (trackPoint.id == expedition.retireAddress.id) {
            trackPointMap.putIfAbsent(
              trackPoint.id,
                  () => TrackPointSummary(trackPoint, 'RETIRE', [], 0, 0, owner: expedition.owner),
            );
            trackPointMap[trackPoint.id]!.retireCount++;
            trackPointMap[trackPoint.id]!.packages.addAll(expedition.packages);
          } else if (trackPoint.id == expedition.destinationAddress.id) {
            trackPointMap.putIfAbsent(
              trackPoint.id,
                  () => TrackPointSummary(trackPoint, 'DESTINATION', [], 0, 0, owner: expedition.owner),
            );
            trackPointMap[trackPoint.id]!.destinationCount++;
            trackPointMap[trackPoint.id]!.packages.addAll(expedition.packages);
          }
        }
      }
    }

    setState(() {
      trackPointSummary = trackPointMap.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 20, left: 20),
          child: Column(
            children: [
              Text(
                  '${AppLocalizations.of(context).translate("departureDate")}: ${widget.track.travelDate}',
                  style: blackText14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.track.origin,
                    style: blackText14,
                  ),
                  Icon(
                    Icons.arrow_right_alt,
                    size: 20,
                  ),
                  Text(
                    widget.track.destination,
                    style: blackText14,
                  ),
                ],
              ),
              AnimatedRotation(
                  turns: showDetails ? 0.5 : 0,
                  duration: Duration(milliseconds: 500),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          showDetails = !showDetails;
                        });
                      },
                      child: Icon(Icons.arrow_drop_down)))
            ],
          ),
        ),
        if (widget.track.trackState == TrackStates.CREATED && showDetails == true)
          AnimatedOpacity(
            opacity: showDetails ? 1.0 : 0.0, // Opacità animata
            duration: Duration(milliseconds: 500), // Durata animazione
            curve: Curves.easeInOut, // Curve di animazione
            child: Visibility(
              visible: showDetails, // Nasconde il widget dallo spazio
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 20),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                          widget.track.expeditions.length,
                          (index) => Column(
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context).translate("load")}: ${index + 1}'),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(AppLocalizations.of(context)
                                              .translate("retireCity")),
                                          Text(widget.track.expeditions[index]
                                              .retireAddress.city),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(AppLocalizations.of(context)
                                              .translate("destinationCity")),
                                          Text(widget.track.expeditions[index]
                                              .destinationAddress.city),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(widget.track.expeditions[index].paid
                                      ? AppLocalizations.of(context)
                                          .translate("expeditionPaid")
                                      : AppLocalizations.of(context)
                                          .translate("expeditionStillNotPaid")),
                                ],
                              )),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          for(var expedition in widget.track.expeditions){
                            // if(expedition.paid){
                            //   UserNotification noti = UserNotification(const Uuid().v4(), AppLocalizations.of(context).translate("expeditionConfirmed"), AppLocalizations.of(context).translate("yourExpeditionConfirmed"), false,'EXPEDITION CONFIRMED', expedition, widget.track);
                            //   sendOnTheWayNotification(noti.id, expedition.owner.token, AppLocalizations.of(context).translate("expeditionConfirmed"), AppLocalizations.of(context).translate("yourExpeditionConfirmed"), expedition, widget.track,'EXPEDITION CONFIRMED');
                            //   if(expedition.owner.userType == UserType.GIURIDICPERSON){
                            //     await FirebaseDatabase().saveLegalPersonNotification(expedition.owner.id, noti.id);
                            //   } else {
                            //     await FirebaseDatabase().savePhysicPersonNotification(expedition.owner.id, noti.id);
                            //   }
                            //   await FirebaseDatabase().saveNotification(noti);
                            // } else {
                            //   UserNotification noti = UserNotification(const Uuid().v4(), AppLocalizations.of(context).translate("expeditionDeleted"), AppLocalizations.of(context).translate("yourExpeditionDeleted"), false,'EXPEDITION CONFIRMED', expedition, widget.track);
                            //   sendOnTheWayNotification(noti.id, expedition.owner.token, AppLocalizations.of(context).translate("expeditionDeleted"), AppLocalizations.of(context).translate("yourExpeditionDeleted"), expedition, widget.track,'EXPEDITION CONFIRMED');
                            //   if(expedition.owner.userType == UserType.GIURIDICPERSON){
                            //     await FirebaseDatabase().saveLegalPersonNotification(expedition.owner.id, noti.id);
                            //   } else {
                            //     await FirebaseDatabase().savePhysicPersonNotification(expedition.owner.id, noti.id);
                            //   }
                            //   await FirebaseDatabase().saveNotification(noti);
                            // }
                          }
                          await FirebaseDatabase().onTheWayTrack(widget.track);
                        },
                        child: Text(AppLocalizations.of(context)
                            .translate("onTheWay"))),
                  ],
                ),
              ),
            ),
          ),
        if (widget.track.trackState == TrackStates.ONTHEWAY && showDetails == true)
          onTheWayStateRender(),
        if (widget.track.trackState == TrackStates.STARTED && showDetails == true)
          Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                trackPointSummary.length, (index) => Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(trackPointSummary[index].address.city, style: TextStyle(
                                    color: trackPointSummary[index].address.id == selectedAddress!.id ? Colors.red : Colors.black
                                  ),),
                                  if(trackPointSummary[index].retireCount > 0)Text('${AppLocalizations.of(context)
                                      .translate("orderToLoad")}: ${trackPointSummary[index].retireCount}'),
                                  if(trackPointSummary[index].destinationCount > 0)Text('${AppLocalizations.of(context)
                                      .translate("orderToDownload")}: ${trackPointSummary[index].destinationCount}'),
                                  InkWell(
                                    onTap: ()async{
                                      await sendCall('+39${widget.track.truckDriver.phone}', '+39${trackPointSummary[index].owner?.phone}');
                                    },
                                    child: Text(AppLocalizations.of(context)
                                        .translate("call")),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                            height: 50), // Spazio per evitare sovrapposizione
                        ElevatedButton(
                          onPressed: ()async{
                            if(currentIndex < trackPointSummary.length -1){
                              setState(() {
                                currentIndex  += 1;
                              });
                              setState(() {
                                selectedAddress = trackPointSummary[currentIndex].address;
                              });
                            }
                            await FirebaseDatabase().setActualCity(widget.track, trackPointSummary[currentIndex].address);
                            if(currentIndex == widget.track.trackPoints!.length -1){
                              await FirebaseDatabase().setTrackToComplete(widget.track);
                            }
                          },
                          child: Text(currentIndex == widget.track.trackPoints!.length -1 ? 'Completato' : 'Avanti'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          )
      ],
    );
  }
}
