import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lucky_way_ios/ui/cards/track_card.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/sender_screens/expeditions_wrapper.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_btn.dart';
import 'package:lucky_way_ios/ui/cards/selector_widget_card_2.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../models/expedition_model.dart';
import '../../ui/custom_divider.dart';
import '../../ui/input/address_auto_complete_field.dart';
import '../../utils/get_city_coordinates.dart';
import '../../utils/handle_expeditions.dart';
import 'new_expedition_screen.dart';

class SenderTrackScreen extends StatefulWidget {
  final Function onItemTapped;
  const SenderTrackScreen({super.key, required this.onItemTapped});

  @override
  State<SenderTrackScreen> createState() => _SenderTrackScreenState();
}

class _SenderTrackScreenState extends State<SenderTrackScreen> with WidgetsBindingObserver{
  final String _apiKey = 'AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U';
  String retireCity = '';
  String retireStreet = '';
  String retireNumber = '';
  String retireCap = '';
  String retireProvince = '';
  String destinationCity = '';
  String destinationStreet = '';
  String destinationNumber = '';
  String destinationCap = '';
  String destinationProvince = '';
  bool notFound = false;
  List<TrackModel> tracksNear = [];
  bool showDetails = false;
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final CollectionReference<Map<String, dynamic>> _physicPersonsCollection =
  FirebaseFirestore.instance.collection('physicPersons');
  final CollectionReference<Map<String, dynamic>> _legalPersonsCollection =
  FirebaseFirestore.instance.collection('legalPersons');
  ExpeditionModel? selectedExpedition;
  bool showExpeditions = false;
  TrackModel? selectedTrack;

  bool showLoader = false;
  bool submitted = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;

    if (newValue != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newValue;
      });
      print('Keyboard is ${isKeyboardVisible ? "open" : "closed"}');
    }
  }

  void setRetireCity(String value) {
    setState(() {
      retireCity = value;
    });
  }

  void setRetireStreet(String value) {
    setState(() {
      retireStreet = value;
    });
  }

  void setRetireNumber(String value) {
    setState(() {
      retireNumber = value;
    });
  }

  void setRetireCap(String value) {
    setState(() {
      retireCap = value;
    });
  }

  void setRetireProvince(String value) {
    setState(() {
      retireProvince = value;
    });
  }

  void setDestinationCity(String value) {
    setState(() {
      retireCity = value;
    });
  }

  void setDestinationStreet(String value) {
    setState(() {
      destinationStreet = value;
    });
  }

  void setDestinationNumber(String value) {
    setState(() {
      destinationNumber = value;
    });
  }

  void setDestinationCap(String value) {
    setState(() {
      destinationCap = value;
    });
  }

  void setDestinationProvince(String value) {
    setState(() {
      destinationProvince = value;
    });
  }

  void setSelectedTrack(TrackModel track) {
    if (selectedTrack != null) {
      setState(() {
        selectedTrack = null;
      });
    } else {
      setState(() {
        selectedTrack = track;
      });
    }
  }

  void setSelectedExpedition(ExpeditionModel ex) {
    if (selectedExpedition == ex) {
      setState(() {
        selectedExpedition = null;
      });
    } else {
      setState(() {
        selectedExpedition = ex;
      });
    }
  }

  Widget notFoundTrack() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).translate("noTrackFound"),
            style: blackText18,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context).translate("doNotWorry"),
            style: blueText14w700,
          ),
          SizedBox(
            height: 20,
          ),
          CustomDivider(
            color: primaryBlue,
          ),
          SelectorWidgetCard2(
            image: 'assets/plus.svg',
            action: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewExpeditionScreen()),
              );
            },
            actionText:
            AppLocalizations.of(context).translate("addAExpedition"),
            border: primaryBlue,
          ),
          SelectorWidgetCard2(
            image: 'assets/search.svg',
            action: () {
              setState(() {
                submitted = false;
                notFound = false;
              });
            },
            actionText:
            AppLocalizations.of(context).translate("findAnotherTrack"),
            border: primaryBlue,
          )
        ],
      ),
    );
  }

  void setShowExpeditions() {
    setState(() {
      showExpeditions = true;
      showDetails = false;
    });
  }

  Widget content() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context).translate("trackPageInfo"),
                style: greyText18,
              ),
              SizedBox(
                height: 40,
              ),
              AddressAutocompleteField(
                label: AppLocalizations.of(context).translate("retireAddress"),
                apiKey: _apiKey,
                selectedCity: retireCity,
                selectedStreet: retireStreet,
                selectedPostalCode: retireCap,
                selectedNumber: retireNumber,
                selectedProvince: retireProvince,
                setCity: setRetireCity,
                setStreet: setRetireStreet,
                setCivicNumber: setRetireNumber,
                setPostalCode: setRetireCap,
                setProvince: setRetireProvince,
              ),
              SizedBox(
                height: 30,
              ),
              AddressAutocompleteField(
                label: AppLocalizations.of(context)
                    .translate("destinationAddress"),
                apiKey: _apiKey,
                selectedCity: destinationCity,
                selectedStreet: destinationStreet,
                selectedPostalCode: destinationCap,
                selectedNumber: destinationNumber,
                selectedProvince: destinationProvince,
                setCity: setDestinationCity,
                setStreet: setDestinationStreet,
                setCivicNumber: setDestinationNumber,
                setPostalCode: setDestinationCap,
                setProvince: setDestinationProvince,
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tracksRender() {
    int pageCount = (tracksNear.length / 3).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 30),

          if (selectedTrack != null)
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 20, // stessa altezza dell’altro ramo
              child: TrackCard(
                isDriver: false,
                track: selectedTrack!,
                setSelectedTrack: setSelectedTrack,
                setShowExpeditions: setShowExpeditions,
                selectedTrack: selectedTrack,
              ),
            )
          else
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 20,
              child: PageView.builder(
                itemCount: pageCount,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * 3;
                  final end = (pageIndex + 1) * 3;

                  final pageItems = tracksNear.sublist(
                    start,
                    end > tracksNear.length
                        ? tracksNear.length
                        : end,
                  );

                  return Column(
                    children: pageItems.map(
                          (track) {
                        return TrackCard(
                          isDriver: false,
                          track: track,
                          setSelectedTrack: setSelectedTrack,
                          setShowExpeditions: setShowExpeditions,
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),

          if (selectedTrack == null)
            ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, value, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pageCount,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: value == index
                            ? Colors.black
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget render(UserBase user) {
    if (showExpeditions) {
      return Expanded(child: expeditionRender(user));
    } else if (showLoader) {
      return SpinKitCircle(color: grey, size: 20);
    } else if (submitted) {
      if (tracksNear.isEmpty) {
        return notFoundTrack();
      } else {
        return tracksRender(); // << aggiunto return mancante
      }
    } else {
      return content();
    }
  }

  String btnTextRender() {
    if (submitted) {
      if (showExpeditions) {
        return AppLocalizations.of(context).translate("sendRequest");
      } else {
        return AppLocalizations.of(context).translate("goToDashboard");
      }
    } else {
      return AppLocalizations.of(context)
          .translate("search"); // << aggiunto return mancante
    }
  }

  String btnIconRender() {
    if (submitted) {
      if (showExpeditions) {
        return 'assets/send.svg';
      } else {
        return 'assets/back-arrow.svg';
      }
    } else {
      return 'assets/search.svg';
    }
  }

  Future<void> functionsRender() async {
    if (submitted) {
      if (showExpeditions) {
        print('request');
      } else {
        setState(() {
          tracksNear = [];
          submitted = false;
          showLoader = false;
          notFound = false;
        });
      }
    } else {
      setState(() {
        showLoader = true;
      });
      if (retireProvince.isEmpty ||
          retireStreet.isEmpty ||
          retireNumber.isEmpty ||
          retireCity.isEmpty ||
          retireCap.isEmpty) {
        setState(() {
          showLoader = false;
        });
        return;
      }
      final coords = await getAddressCoordinates(
          '$retireStreet $retireNumber, $retireCity, $retireCap, $retireProvince');
      if (coords != null) {
        List<TrackModel> tracks = await FirebaseDatabase().getAllTracks();

        for (var track in tracks) {
          bool isCity = isCityWithinDistance(
              track.polylines, coords!['lat']!, coords!['lng']!, 50);
          if (isCity) {
            tracksNear.add(track);
          }
        }
        if (tracksNear.isEmpty) {
          setState(() {
            submitted = true;
            showLoader = false;
            notFound = true;
          });
        } else {
          setState(() {
            submitted = true;
            showLoader = false;
            notFound = false;
          });
        }
      } else {
        setState(() {
          submitted = true;
          showLoader = false;
          notFound = true;
        });
      }
    }
  }

  Widget btnRender() {
    if (notFound) {
      return SizedBox();
    } else if (showDetails) {
      return SizedBox();
    } else if(showExpeditions){
      return SizedBox();
    } else if(isKeyboardVisible){
      return SizedBox();
    } else {
      return LuckywayBtn(
          text: btnTextRender(),
          backgroundColor: Colors.black,
          textStyle: whiteText14w700,
          icon: btnIconRender(),
          onPressed: () async {
            functionsRender();
          });
    }
  }

  void closeStates(){
    setState(() {
      submitted = false;
      showLoader = false;
      notFound = false;
      showExpeditions = false;
      tracksNear = [];
    });
  }

  Widget expeditionRender(UserBase user) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: (user is PhysicPerson)
          ? _physicPersonsCollection.doc(user.id).snapshots()
          : _legalPersonsCollection.doc(user.id).snapshots(),
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

        return FutureBuilder<List<ExpeditionModel>>(
          future: handleExpeditions(userData!['expeditions']),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (futureSnapshot.hasError) {
              return Center(
                  child: Text(
                    AppLocalizations.of(context).translate("errorGeneral"),
                    style: blackText14,
                  ));
            }
            if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("noExpeditions"),
                    style: greyText18,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LuckywayBtn(
                      text: AppLocalizations.of(context)
                          .translate("addAExpedition"),
                      backgroundColor: Colors.black,
                      textStyle: whiteText14w700,
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => NewExpeditionScreen(
                                track: selectedTrack,

                              )),
                        );
                      })
                ],
              );
            }

            List<ExpeditionModel> expeditions = futureSnapshot.data!;

            final pageCount = (expeditions.length / 3).ceil();

            return Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: ExpeditionsWrapper(expeditions: expeditions, showDetails: showDetails, pageCount: pageCount, selectedTrack: selectedTrack!, closeStates: closeStates),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("tracks"),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            btnRender(),
          ],
        ),
        content: render(user),
        showHeader: true,
        isNavigate: false);
  }
}
