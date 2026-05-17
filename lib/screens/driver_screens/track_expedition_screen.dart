import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/screens/driver_screens/handler_expedition_screen.dart';
import 'package:lucky_way_ios/ui/cards/expedition_card_2.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/track_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/expedition_card.dart';

class TrackExpeditionScreen extends StatefulWidget {
  final TrackModel track;
  TrackExpeditionScreen({super.key, required this.track,});

  @override
  State<TrackExpeditionScreen> createState() => _TrackExpeditionScreenState();
}

class _TrackExpeditionScreenState extends State<TrackExpeditionScreen> {
  PageController pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  ExpeditionModel? selectedExpedition;

  void setSelectedExpedition(ExpeditionModel e){
    if(selectedExpedition != null && selectedExpedition!.id == e.id){
      setState(() {
        selectedExpedition = null;
      });
    } else {
      setState(() {
        selectedExpedition = e;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    List<ExpeditionModel> expeditions = widget.track.expeditions;

    final pageCount = (expeditions.length / 3).ceil();

    Widget render(){
      return expeditions.length == 0 ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text(AppLocalizations.of(context).translate("noExpeditionsOnTrack"), style: greyText18,)
        ],
      ) : Column(
        children: [
          SizedBox(
            height: selectedExpedition != null
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Column(
                      children: pageItems.map(
                            (expedition) => ExpeditionCard2(
                          expedition: expedition,
                              selectedExpedition: selectedExpedition,
                              setSelectedExpedition: setSelectedExpedition,
                        ),
                      ).toList(),
                    ),
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
    }



    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("handleExpeditions"),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: selectedExpedition != null ? AppLocalizations.of(context).translate("handleExpedition") : AppLocalizations.of(context).translate("goBack"), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: selectedExpedition != null ? 'assets/pencil_square.svg' : 'assets/back-arrow.svg', onPressed: (){
              if(selectedExpedition != null){
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => HandlerExpeditionScreen(expedition: selectedExpedition!, track: widget.track)),
                );
              } else {
                Navigator.of(context).pop();
              }
            }),
          ],
        ),
        content: render(),
        showHeader: true,
        isNavigate: true);

  }
}
