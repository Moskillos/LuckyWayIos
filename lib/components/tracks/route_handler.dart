
import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../database.dart';
import '../../models/address_model.dart';
import '../../models/expedition_model.dart';
import '../../models/package_model.dart';
import '../../models/track_model.dart';
import '../../models/user_model.dart';
import '../../utils/send_notifications.dart';

class TrackPointSummary {
  AddressModel address;
  String trackPointType;
  List<PackageModel> packages;
  int retireCount;
  int destinationCount;
  OwnerExModel? owner;

  TrackPointSummary(this.address, this.trackPointType, this.packages, this.retireCount, this.destinationCount,
      {this.owner});
}

class RouteHandler extends StatefulWidget {
  final TrackModel track;
  const RouteHandler({super.key, required this.track});

  @override
  State<RouteHandler> createState() => _RouteHandlerState();
}

class _RouteHandlerState extends State<RouteHandler> {
  List<TrackPointSummary> trackPointSummary = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    processTrackPoints();
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
                  () => TrackPointSummary(trackPoint, 'RETIRE', [], 0, 0),
            );
            trackPointMap[trackPoint.id]!.retireCount++;
            trackPointMap[trackPoint.id]!.packages.addAll(expedition.packages);
          } else if (trackPoint.id == expedition.destinationAddress.id) {
            trackPointMap.putIfAbsent(
              trackPoint.id,
                  () => TrackPointSummary(trackPoint, 'DESTINATION', [], 0, 0),
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(trackPointSummary.length, (index) => Container(
                padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(trackPointSummary[index].address.city),
                      if(trackPointSummary[index].retireCount > 0)Text('${AppLocalizations.of(context)
                          .translate("orderToLoad")}: ${trackPointSummary[index].retireCount}'),
                      if(trackPointSummary[index].destinationCount > 0)Text('${AppLocalizations.of(context)
                          .translate("orderToDownload")}: ${trackPointSummary[index].destinationCount}'),
                    ],
                  ),
                  ))),
          ),
          ),
        ElevatedButton(
          onPressed: () async {
            String started = AppLocalizations.of(context).translate("started");
            String yourLoadLeft = AppLocalizations.of(context).translate("yourLoadLeft");

            await FirebaseDatabase().onDepartureTrack(widget.track);

            // for (var expedition in widget.track.expeditions) {
            //   UserNotification noti = UserNotification(
            //       const Uuid().v4(),
            //       started,
            //       yourLoadLeft,
            //       false,
            //       'LEFT',
            //       expedition,
            //       widget.track
            //   );
            //
            //   sendStartTrackNotification(
            //       noti.id,
            //       expedition.owner.token,
            //       started,
            //       yourLoadLeft,
            //       expedition,
            //       widget.track,
            //     'LEFT'
            //   );
            //
            //   if (expedition.owner.userType == UserType.GIURIDICPERSON) {
            //     await FirebaseDatabase().saveLegalPersonNotification(expedition.owner.id, noti.id);
            //   } else {
            //     await FirebaseDatabase().savePhysicPersonNotification(expedition.owner.id, noti.id);
            //   }
            //
            //   await FirebaseDatabase().saveNotification(noti);
            // }
          },
          child: Text(AppLocalizations.of(context).translate("departure")),
        )
      ],
    );
  }
}
