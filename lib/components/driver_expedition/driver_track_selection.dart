import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/cards/track_card_2.dart';

class DriverTrackSelection extends StatefulWidget {
  final Function setTrack;
  const DriverTrackSelection({super.key, required this.setTrack});

  @override
  State<DriverTrackSelection> createState() => _DriverTrackSelectionState();
}

class _DriverTrackSelectionState extends State<DriverTrackSelection> {
  @override
  Widget build(BuildContext context) {
    TruckDriverModel driver =
        Provider.of<AppState>(context).user as TruckDriverModel;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context).translate("whatTrack"),
              style: greyText18,
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              children: List.generate(
                  driver.tracks.length,
                  (index) => TrackCard2(track: driver.tracks[index], setTrack: widget.setTrack)),
            ),
          ],
        ),
      ),
    );
  }
}
