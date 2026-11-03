import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/expedition_card_2.dart';
import '../../utils/date_format.dart';
import '../../utils/send_notifications.dart';
import '../success_page.dart';

class ExpeditionsWrapper extends StatefulWidget {
  final List<ExpeditionModel> expeditions;
  final bool showDetails;
  final int pageCount;
  final TrackModel selectedTrack;
  final Function closeStates;
  const ExpeditionsWrapper({super.key, required this.expeditions, required this.showDetails, required this.pageCount, required this.selectedTrack, required this.closeStates});

  @override
  State<ExpeditionsWrapper> createState() => _ExpeditionsWrapperState();
}

class _ExpeditionsWrapperState extends State<ExpeditionsWrapper> {
  ExpeditionModel? selectedExpedition;
  PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  bool loader = false;

  void setSelectedExpedition(ExpeditionModel ex){
    if(selectedExpedition == ex){
      setState(() {
        selectedExpedition = null;
      });
    } else {
      setState(() {
        selectedExpedition = ex;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("chooseExpedition"),
          style: greyText12,
        ),
        const SizedBox(height: 20),

        // ← QUI: Expanded invece del SizedBox con MediaQuery
        Expanded(
          child: PageView.builder(
            clipBehavior: Clip.hardEdge,
            controller: _pageController,
            onPageChanged: (index) => _currentPage.value = index,
            itemCount: widget.pageCount,
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * 3;
              final end = (pageIndex + 1) * 3;
              final pageItems = widget.expeditions.sublist(
                start,
                end > widget.expeditions.length
                    ? widget.expeditions.length
                    : end,
              );

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: pageItems
                      .map(
                        (expedition) => ExpeditionCard2(
                      track: widget.selectedTrack,
                      expedition: expedition,
                      setSelectedExpedition: setSelectedExpedition,
                      selectedExpedition: selectedExpedition,
                    ),
                  )
                      .toList(),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        ValueListenableBuilder<int>(
          valueListenable: _currentPage,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.pageCount,
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

        const SizedBox(height: 16),

        loader ? CircularProgressIndicator() : LuckywayBtn(
          text: AppLocalizations.of(context).translate("goOn"),
          backgroundColor: Colors.black,
          textStyle: whiteText14w700,
          onPressed: () async {
            setState(() {
              loader = true;
            });

            await sendNotification(
                widget.selectedTrack.truckDriver.token,
                '${user.name} ${user.lastName}',
                AppLocalizations.of(context).translate("expeditionRequest"),
                "expedition",
                selectedExpedition!.id,
                widget.selectedTrack.id
            );
            setState(() {
              loader = false;
            });
            widget.closeStates();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SuccessPage()),
            );
          },
        ),
      ],
    );
  }
}
