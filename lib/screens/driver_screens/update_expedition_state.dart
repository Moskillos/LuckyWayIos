import 'package:flutter/material.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/chat_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';
import '../../utils/date_format.dart';
import '../../utils/send_notifications.dart';

class UpdateExpeditionState extends StatefulWidget {
  final ExpeditionModel expedition;
  const UpdateExpeditionState({super.key, required this.expedition});

  @override
  State<UpdateExpeditionState> createState() => _UpdateExpeditionStateState();
}

class _UpdateExpeditionStateState extends State<UpdateExpeditionState> {
  bool retired = false;
  bool delivered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      retired = widget.expedition.retired;
      delivered = widget.expedition.completed;
    });

    print(retired);
    print( widget.expedition.retired);
    print(delivered);
    print(widget.expedition.completed);
  }

  @override
  Widget build(BuildContext context) {
    TruckDriverModel user = Provider.of<AppState>(context).user as TruckDriverModel;

    return LuckyWayLayout(
        isNavigate: true,
        showHeader: true,
        title: AppLocalizations.of(context).translate("updateStatus"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate("updateExpeditionStatus"),
                style: greyText18,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate("expeditionCode"),
                        style: blueText16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.expedition.id,
                        style: blueText14w700,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDivider(
                    color: grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .translate("expeditionHasBeenRetired"),
                          style: blackText14w700),
                      Switch(
                        value: retired,
                        onChanged: (bool value) async {
                          setState(() {
                            retired = value;
                          });
                          if (retired) {
                            await FirebaseDatabase().setExpeditionToRetired(widget.expedition.id);
                            print("retired");
                            print(retired);
                            await sendNotification(widget.expedition.owner.token, '${user.name} ${user.lastName}', AppLocalizations.of(context).translate("expeditionRetired"), "acceptation", widget.expedition.id, "");

                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: primaryBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        trackOutlineColor: MaterialStateProperty.all(
                            Colors.black), // <-- Colore bordo track
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDivider(
                    color: grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .translate("expeditionHasBeenDelivered"),
                          style: blackText14w700),
                      Switch(
                        value: delivered,
                        onChanged: (bool value) async {
                          setState(() {
                            delivered = value;
                          });
                          if (delivered) {
                            await FirebaseDatabase().setExpeditionToComplete(widget.expedition);
                            await sendNotification(widget.expedition.owner.token, '${user.name} ${user.lastName}', AppLocalizations.of(context).translate("expeditionDelivered"), "acceptation", widget.expedition.id, "");

                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: primaryBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        trackOutlineColor: MaterialStateProperty.all(
                            Colors.black), // <-- Colore bordo track
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(
                text: AppLocalizations.of(context).translate("goBack"),
                backgroundColor: Colors.black,
                textStyle: whiteText14w700,
                icon: 'assets/back-arrow.svg',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ));
  }
}
