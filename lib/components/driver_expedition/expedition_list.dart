import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/expedition_model.dart';
import '../../ui/cards/expedition_card.dart';
import '../../ui/cards/selector_widget_card_2.dart';
import '../../ui/custom_divider.dart';
import '../../utils/handle_expeditions.dart';

class ExpeditionList extends StatefulWidget {
  final String city;
  final CollectionReference<Map<String, dynamic>> expeditionsCollection;
  final Function setExpedition;
  final ExpeditionModel? selectedExpedition;
  final Function changePage;
  ExpeditionList({super.key, required this.city, this.selectedExpedition, required this.expeditionsCollection, required this.setExpedition, required this.changePage});

  @override
  State<ExpeditionList> createState() => _ExpeditionListState();
}

class _ExpeditionListState extends State<ExpeditionList> {
  PageController pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: (widget.city.isEmpty
          ? widget.expeditionsCollection
          .where('accepted', isEqualTo: false)
          .snapshots()
          : widget.expeditionsCollection
          .where("retireAddress.city", isEqualTo: widget.city)
          .where('accepted', isEqualTo: false)
          .snapshots()),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (snapshot.hasError) {
          return const SizedBox();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context).translate("noExpeditions"),
                style: greyText18,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context).translate("doNotWorryEx"),
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
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => NewTrackScreen()),
                  // );
                },
                actionText:
                AppLocalizations.of(context).translate("addATrack"),
                border: primaryBlue,
              ),
              SelectorWidgetCard2(
                image: 'assets/search.svg',
                action: () {
                  Navigator.of(context).pop();
                },
                actionText:
                AppLocalizations.of(context).translate("findAnotherExpedition"),
                border: primaryBlue,
              )
            ],
          );
        }

        final expeditionsDocs = snapshot.data!.docs;
        final expeditionsData = expeditionsDocs.map((doc) => doc.data()).toList();

        return FutureBuilder<List<ExpeditionModel>>(
          future: handleDriverExpeditions(expeditionsData),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (futureSnapshot.hasError) {
              return Center(
                  child: Text(AppLocalizations.of(context).translate("errorGeneral"), style: blackText14,));
            }
            if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: SizedBox(),
              );
            }

            List<ExpeditionModel> expeditions = futureSnapshot.data!;

            final pageCount = (expeditions.length / 3).ceil();
            return Column(
              children: [
                SizedBox(
                  height: widget.selectedExpedition != null
                      ? MediaQuery.of(context).size.height / 2 + 20
                      : (MediaQuery.of(context).size.height / 2) - 20,
                  child: PageView.builder(
                    clipBehavior: Clip.none,
                    controller: pageController,
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
                        child: widget.selectedExpedition != null ?
                        ExpeditionCard(
                          changePage: widget.changePage,
                          setExpedition: widget.setExpedition,
                          isDriver: true,
                          expedition: widget.selectedExpedition!,
                        ) :
                        Column(
                          children: pageItems.map(
                                (expedition) => ExpeditionCard(
                                  changePage: widget.changePage,
                                  setExpedition: widget.setExpedition,
                                  isDriver: true,
                              expedition: expedition,
                            ),
                          ).toList(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                            color: value == index ? Colors.black : Colors.grey[300],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
