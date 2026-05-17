
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/components/header.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/sender_screens/new_expedition_screen.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_btn.dart';
import 'package:lucky_way_ios/ui/buttons/main_btn.dart';
import 'package:lucky_way_ios/ui/cards/expedition_card.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

import '../../app_localizations.dart';
import '../../database.dart';
import '../../store/app_state.dart';
import '../../utils/handle_expeditions.dart';
import '../../utils/send_call.dart';

class ExpeditionScreen extends StatefulWidget {
  const ExpeditionScreen({super.key});

  @override
  State<ExpeditionScreen> createState() => _ExpeditionScreenState();
}

class _ExpeditionScreenState extends State<ExpeditionScreen> {
  final ValueNotifier<bool> isUserInteracting = ValueNotifier(false);
  final CollectionReference<Map<String, dynamic>> _physicPersonsCollection = FirebaseFirestore.instance.collection('physicPersons');
  final CollectionReference<Map<String, dynamic>> _legalPersonsCollection =
  FirebaseFirestore.instance.collection('legalPersons');
  ExpeditionModel? selectedExpedition;
  PageController _pageController = PageController(viewportFraction: 1);
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  int step = 0;

  void setExpedition(ExpeditionModel ex){
    if(selectedExpedition != null && selectedExpedition!.id == ex.id){
      setState(() {
        selectedExpedition = null;
      });
    } else {
      setState(() {
        selectedExpedition = ex;
      });
    }

  }

  void changePage() {
    setState(() {
      step = step + 1;
    });
    _pageController.jumpToPage(step);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    
    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("myExpeditions"),
        button: selectedExpedition != null ? SizedBox() : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 30,
        ),
        LuckywayBtn(text: AppLocalizations.of(context).translate("addAExpedition"), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: 'assets/plus.svg', onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NewExpeditionScreen()),
          );
        }),
      ],
    ),
        content: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: (user is PhysicPerson) ? _physicPersonsCollection.doc(user.id).snapshots() : _legalPersonsCollection.doc(user.id).snapshots(),
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
                      child: Text(AppLocalizations.of(context).translate("errorGeneral"), style: blackText14,));
                }
                if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text(AppLocalizations.of(context).translate("noExpeditions"), style: greyText18,),
                    ],
                  );
                }

                List<ExpeditionModel> expeditions = futureSnapshot.data!;

                final pageCount = (expeditions.length / 3).ceil();

                return  Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: selectedExpedition != null
                            ? MediaQuery.of(context).size.height / 2.2 + 100
                            : (MediaQuery.of(context).size.height / 2.1),
                        child: selectedExpedition != null ? SingleChildScrollView(
                          child: ExpeditionCard(
                            changePage: changePage,
                            isDriver: false,
                            expedition: selectedExpedition!,
                            setExpedition: setExpedition,
                            selectedExpedition: selectedExpedition,
                          ),
                        ) : PageView.builder(
                          clipBehavior: Clip.none,
                          controller: _pageController,
                          onPageChanged: (index) => _currentPage.value = index,
                          itemCount: pageCount,
                          itemBuilder: (context, pageIndex) {
                            final start = pageIndex * 3;
                            final end = (pageIndex + 1) * 3;
                            final pageItems = expeditions.sublist(
                              start,
                              end > expeditions.length ? expeditions.length : end,
                            );

                            return SingleChildScrollView(
                              child: Column(
                                children: pageItems.map(
                                      (expedition) => ExpeditionCard(
                                        changePage: changePage,
                                        isDriver: false,
                                    expedition: expedition,
                                    setExpedition: setExpedition,
                                  ),
                                ).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      if(selectedExpedition == null)ValueListenableBuilder<int>(
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
                                  color: value == index ? Colors.black : Colors.grey[300],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        showHeader: true, isNavigate: false,);

  }
}