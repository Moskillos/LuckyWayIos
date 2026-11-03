import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/screens/payment_page.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_icon_btn.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../stripe_service.dart';
import '../../utils/date_format.dart';
import '../../utils/expedition_state.dart';
import '../../utils/send_notifications.dart';
import '../buttons/luckyway_btn.dart';

class ExpeditionCardNotification extends StatefulWidget {
  final ExpeditionModel expedition;
  final bool isDriver;
  final TrackModel track;
  ExpeditionModel? selectedExpedition;
  bool? engage;
  ExpeditionCardNotification({super.key, required this.expedition, required this.isDriver,required this.track, this.selectedExpedition, this.engage});

  @override
  State<ExpeditionCardNotification> createState() => _ExpeditionCardNotificationState();
}

class _ExpeditionCardNotificationState extends State<ExpeditionCardNotification> {
  bool loader = false;


  Future<void> expeditionFunctionsState(ExpeditionModel expedition, context, UserBase user)async {
    if (expedition.accepted) {
      if (expedition.completed) {

      } else {
        if (expedition.paid) {

        } else {
          final subscription = await StripePaymentService().createPaymentIntent(
            expedition.offer,
            'EUR',
          );

        }
      }
    }else {
      if (expedition.paid) {

      } else {
        Provider.of<AppState>(context, listen: false).deleteExpedition(expedition);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;


    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: expeditionColorState(widget.expedition, context), width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate("date"),
                    style: blackText14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    dateFormat(DateTime.now()),
                    style: blackText14w700,
                  )
                ],
              ),
              Row(children: [
                Text(
                  AppLocalizations.of(context).translate("track"),
                  style: blackText14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                    '${widget.expedition.retireAddress.city} - ${widget.expedition.destinationAddress.city}',
                    style: blackText14w700),
              ]),
              Row(children: [
                Text(
                  AppLocalizations.of(context).translate("sender2"),
                  style: blackText14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.expedition.sender.name, style: blackText14w700),
              ]),
              Row(children: [
                Text(
                  AppLocalizations.of(context).translate("expeditionCode"),
                  style: blackText14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.expedition.id, style: blackText14w700),
              ]),
              SizedBox(
                height: 5,
              ),
              CustomDivider(),
              SizedBox(
                height: 5,
              ),
              widget.selectedExpedition != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("expeditionState"),
                        style: blackText14,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        expeditionState(widget.expedition, context),
                        style: blackText14w700,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(expeditionInfoState(widget.expedition, context), style: greyText12,),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate("numberArticles"),
                        style: blackText14,
                      ),
                      Text(widget.expedition.packages.length.toString(),
                          style: blackText14w700),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate("merchandiseTypologies"),
                        style: blackText14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            widget.expedition.packages.length,
                                (index) => Text(
                                widget.expedition.packages[index]
                                    .merchandise,
                                style: blackText14w700)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate("dimensions"),
                            style: blackText14,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: List.generate(
                                widget.expedition.packages.length,
                                    (index) => Text(
                                    '${widget.expedition.packages[index].length}x${widget.expedition.packages[index].width}x${widget.expedition.packages[index].height} cm - ${widget.expedition.packages[index].weight}Kg',
                                    style: blackText14w700)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate("retireAddress2"),
                            style: blackText14,
                          ),
                          Text(
                              '${widget.expedition.retireAddress.street}, ${widget.expedition.retireAddress.civicNumber}, ${widget.expedition.retireAddress.cap}, ${widget.expedition.retireAddress.city}',
                              style: blackText14w700),
                          Text(
                              '${widget.expedition.retireAddress.province}',
                              style: blackText14w700),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate("destinationAddress2"),
                            style: blackText14,
                          ),
                          Text(
                              '${widget.expedition.destinationAddress.street}, ${widget.expedition.destinationAddress.civicNumber}, ${widget.expedition.destinationAddress.cap}, ${widget.expedition.destinationAddress.city}',
                              style: blackText14w700),
                          Text(
                              '${widget.expedition.destinationAddress.province}',
                              style: blackText14w700),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate("offer2"),
                              style: blackText14,
                            ),
                            Text(
                                '${widget.expedition.offer},00€',
                                style: blackText14w700),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      widget.isDriver ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.engage != null ? SizedBox() : LuckywayBtn(text: AppLocalizations.of(context)
                              .translate("reject"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: () async {
                            await sendNotification(widget.expedition.owner.token, '${user.name} ${user.lastName}', AppLocalizations.of(context).translate("offerRejected"), 'reject', widget.expedition.id, widget.track.id);
                            Navigator.pop(context);
                          }),
                          SizedBox(width: 10,),
                          loader ? CircularProgressIndicator() : LuckywayBtn(text: AppLocalizations.of(context)
                              .translate("accept"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: () async {
                            setState(() {
                              loader = true;
                            });
                            await Provider.of<AppState>(context, listen: false).addExpeditionToTrack(widget.track, widget.expedition);
                            await sendNotification(widget.expedition.owner.token, '${user.name} ${user.lastName}', AppLocalizations.of(context).translate("offerAccepted"), 'acceptation', widget.expedition.id, widget.track.id);
                            setState(() {
                              loader = false;
                            });
                            Navigator.pop(context);
                          })
                        ],
                      ) : LuckywayBtn(
                          text: expeditionButtonState(widget.expedition, context), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: expeditionIconState(widget.expedition, context), onPressed: (){
                        expeditionFunctionsState(widget.expedition, context, user);
                      }),
                    ],
                  ),
                ],
              )
                  : LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("expeditionDetails"),
                          style: blackText14w700,
                        ),
                      )
                    ],
                  ),
                );
              }
              )
            ],
          ),
          Positioned(top: 5, right: 5, child: SvgPicture.asset(
            expeditionMainIconState(widget.expedition, context),
            color: expeditionColorState(widget.expedition, context),
            height: 30,
            width: 30,
          ))
        ],
      ),
    );
  }
}
