import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/ui/cards/track_card.dart';
import 'package:lucky_way_ios/screens/driver_screens/new_track_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/track_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';

class DriverTrackScreen extends StatefulWidget {
  const DriverTrackScreen({super.key});

  @override
  State<DriverTrackScreen> createState() => _DriverTrackScreenState();
}

class _DriverTrackScreenState extends State<DriverTrackScreen> {
  final CollectionReference<Map<String, dynamic>> _truckDriversCollection =
      FirebaseFirestore.instance.collection('truckDrivers');
  TrackModel? selectedTrack;
  PageController _pageController = PageController(viewportFraction: 1);
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  ScrollController scrollController = ScrollController();

  Future<List<TrackModel>> handleTracks(tracks) async {
    List<TrackModel> trackList = [];
    for (var track in tracks) {
      TrackModel t = await FirebaseDatabase().getTrack(track);
      trackList.add(t);
    }
    return trackList;
  }

  void setSelectedTrack(TrackModel track) {
    if (selectedTrack != null && selectedTrack!.id == track.id) {
      setState(() {
        selectedTrack = null;
      });
    } else {
      setState(() {
        selectedTrack = track;
      });
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserAndTracksStream(
      String userId) {
    final userStream = _truckDriversCollection.doc(userId).snapshots();
    final tracksStream =
        FirebaseFirestore.instance.collection('tracks').snapshots();

    return Rx.combineLatest2(userStream, tracksStream, (user, tracks) => user);
  }

  @override
  Widget build(BuildContext context) {
    TruckDriverModel user =
        Provider.of<AppState>(context).user as TruckDriverModel;

    return LuckyWayLayout(
      title: AppLocalizations.of(context).translate("myTracks"),
      button: selectedTrack != null ? SizedBox() : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          LuckywayBtn(text: AppLocalizations.of(context).translate("addATrack"), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: 'assets/plus.svg', onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => NewTrackScreen()),
            );
          }),
        ],
      ),
        content: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getUserAndTracksStream(user.id),
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


            return FutureBuilder<List<TrackModel>>(
              future: handleTracks(userData!['tracks']),
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
                if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Center(child: Text(AppLocalizations.of(context).translate("noTracks"), style: greyText18, textAlign: TextAlign.start,)),
                  );
                }

                List<TrackModel> tracksMapped = futureSnapshot.data!;

                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      selectedTrack != null
                          ? SizedBox(
                        height: MediaQuery.of(context).size.height / 2.2,
                            child: SingleChildScrollView(
                              child: TrackCard(
                                                          isDriver: true,
                                                          track: selectedTrack!,
                                setSelectedTrack: setSelectedTrack,
                                                          selectedTrack: selectedTrack,
                                                          setShowExpeditions: (){},
                                                        ),
                            ),
                          )


                           : SizedBox(
                        height: (MediaQuery.of(context).size.height / 2) - 20,
                        child:
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                tracksMapped.length,
                                    (index) => TrackCard(
                                  isDriver: true,
                                  track: tracksMapped[index],
                                  setSelectedTrack: setSelectedTrack,
                                  setShowExpeditions: () {},
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      showHeader: true,
      isNavigate: false,
    );
  }
}
