import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/components/driver_expedition/driver_expedition_address.dart';
import 'package:lucky_way_ios/components/driver_expedition/driver_expedition_found.dart';
import 'package:lucky_way_ios/components/driver_expedition/driver_expedition_offer.dart';
import 'package:lucky_way_ios/components/driver_expedition/driver_track_selection.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/models/chat_model.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_btn.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../layout/page_view_builder_layout.dart';
import '../../store/app_state.dart';
import '../../utils/date_format.dart';
import '../../utils/send_notifications.dart';

class DriverExpeditionScreen extends StatefulWidget {
  const DriverExpeditionScreen({super.key});

  @override
  State<DriverExpeditionScreen> createState() => _DriverExpeditionScreenState();
}

class _DriverExpeditionScreenState extends State<DriverExpeditionScreen> {
  PageController pageController = PageController(viewportFraction: 1);
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  int step = 0;
  String expeditionView = "";
  final CollectionReference<Map<String, dynamic>> _expeditionsCollection = FirebaseFirestore.instance.collection('expeditions');
  bool showDetails = false;
  String offerAccepted = '';
  TextEditingController offerController = TextEditingController();
  String newOffer = '';
  TrackModel? selectedTrack;
  ExpeditionModel? selectedExpedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inizializza solo se non è già stato impostato
    if (expeditionView.isEmpty) {
      setState(() {
        expeditionView = AppLocalizations.of(context).translate("list");
      });
    }
    if (offerAccepted.isEmpty) {
      setState(() {
        offerAccepted = AppLocalizations.of(context).translate("yes");
      });
    }
  }

  void changePage() {

    setState(() {
      step = step + 1;
    });
    pageController.jumpToPage(step);
  }

  void setExpedition(ExpeditionModel expedition) {
    setState(() {
      selectedExpedition = expedition;
    });
    changePage();
  }

  void setCity(String value){
    setState(() {
      selectedCity = value;
    });

  }

  void setStreet(String value){
    setState(() {
      selectedStreet = value;
    });

  }

  void setCivicNumber(String value){
    setState(() {
      selectedNumber = value;
    });

  }

  void setPostalCode(String value){
    setState(() {
      selectedPostalCode = value;
    });

  }

  void setProvince(String value){
    setState(() {
      selectedProvince = value;
    });

  }

  void setExpeditionView(String value){
    setState(() {
      expeditionView = value;
    });
  }

  void setOfferAcceptation(String value){
    if(value == AppLocalizations.of(context)
        .translate("no")){
      setState(() {
        newOffer = '';
        offerController.text = '';
      });
    }
    setState(() {
      offerAccepted = value;
    });
  }

  void setNewOffer(String value){
    setState(() {
      newOffer = value;
    });
  }

  void setTrack(TrackModel t){
    setState(() {
      selectedTrack = t;
    });
    changePage();
  }

  @override
  Widget build(BuildContext context) {
  TruckDriverModel driver = Provider.of<AppState>(context).user as TruckDriverModel;

    List<Widget> pages = [
      DriverExpeditionAddress(
          setCity: setCity,
          setProvince: setProvince,
          setStreet: setStreet,
          setCivicNumber: setCivicNumber,
          setPostalCode: setPostalCode,
          selectedCity: selectedCity,
          selectedStreet: selectedStreet,
          selectedNumber: selectedNumber,
          selectedPostalCode: selectedPostalCode,
          selectedProvince: selectedProvince
      ),
      DriverExpeditionFound(
        changePage: changePage,
          setExpedition: setExpedition,
          expeditionsCollection: _expeditionsCollection,
          selectedExpedition: selectedExpedition,
          city: selectedCity ?? '',
          value: expeditionView,
          onChanged: setExpeditionView,
          firstItem: AppLocalizations.of(context).translate("list"),
          secondItem: AppLocalizations.of(context).translate("map")),
      DriverTrackSelection(
        setTrack: setTrack,
      ),
      DriverExpeditionOffer(
        value: offerAccepted,
        onChanged: setOfferAcceptation,
        firstItem: AppLocalizations.of(context).translate("yes"),
        secondItem: AppLocalizations.of(context).translate("no"),
        offerController: offerController,
        setNewOffer: setNewOffer,
        disableText: AppLocalizations.of(context).translate("yes")
      ),
      offerAccepted == AppLocalizations.of(context)
          .translate("yes") ? SuccessScreen(title: AppLocalizations.of(context).translate("expeditionAssigned")) :
      SuccessScreen(title: AppLocalizations.of(context).translate("offerSent"), description: AppLocalizations.of(context).translate("crossFinger"),)
    ];


    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("findExpedition"),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            if(step != 1 && step != 2)LuckywayBtn(text: AppLocalizations.of(context).translate("goOn"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: () async {
              if(step == 3){
                if(selectedExpedition != null){
                  var uuid = Uuid();
                  String chatId = 'C${uuid.v4().substring(0, 8)}';
                  List<ChatUser> participants = [
                    ChatUser(driver.id, UserType.TRUCKDRIVER, '${driver.name} ${driver.lastName}', driver.profileImage),
                    ChatUser(selectedExpedition!.owner.id, selectedExpedition!.owner.userType, selectedExpedition!.owner.ownerName, selectedExpedition!.owner.profileImage),
                  ];
                  String chatMessageId = 'MESS${uuid.v4().substring(0, 8)}';

                  String timeStamp = timeFormat(DateTime.now());

                  if(offerAccepted == AppLocalizations.of(context).translate("no")){
                    if(newOffer.isNotEmpty){
                      ChatMessage firstMessage = ChatMessage(chatMessageId, driver.id, AppLocalizations.of(context).translate("newOffer"), timeStamp, false,answered: false, offer: newOffer, expedition: selectedExpedition!.id, track: selectedTrack!.id);

                      List<ChatMessage> messages = [
                        firstMessage,
                      ];

                      ChatModel chat = ChatModel(chatId, participants, messages.last.content, timeStamp, messages,);
                      Provider.of<AppState>(context, listen: false).createChat(chat);

                      await sendNotification(selectedExpedition!.owner.token, '${driver.name} ${driver.lastName}', messages.last.content,  chat.id, null);
                    }
                  } else {
                    await Provider.of<AppState>(context, listen: false).addExpeditionToTrack(selectedTrack!, selectedExpedition!);
                    ChatMessage firstMessage = ChatMessage(chatMessageId, driver.id, AppLocalizations.of(context).translate("expeditionExcepted"), timeStamp, false,answered:  true);
                    List<ChatMessage> messages = [
                      firstMessage,
                    ];

                    ChatModel chat = ChatModel(chatId, participants, messages.last.content, timeStamp, messages);
                    await Provider.of<AppState>(context, listen: false).createChat(chat);
                    await sendNotification(selectedExpedition!.owner.token, '${driver.name} ${driver.lastName}', messages.last.content, chatId, null);
                  }
                }
              }
              if(step == 4){
                step = 0;
                return;
              }
                changePage();
            }),
          ],
        ),
        content: PageViewBuilderLayout(
          pageController: pageController,
          pages: pages,
        ),
        showHeader: true,
        isNavigate: false);
  }
}
