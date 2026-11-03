import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/screens/payment_page.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_icon_btn.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../components/expeditions/publish_expedition.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/address_model.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../stripe_service.dart';
import '../../utils/date_format.dart';
import '../../utils/expedition_state.dart';
import '../../utils/send_notifications.dart';
import '../buttons/luckyway_btn.dart';

class ExpeditionCard extends StatefulWidget {
  final Function setExpedition;
  final ExpeditionModel expedition;
  final bool isDriver;
  final Function changePage;
  ExpeditionModel? selectedExpedition;
  bool? engage;
  ExpeditionCard({super.key, required this.expedition, required this.setExpedition, required this.isDriver,required this.changePage, this.selectedExpedition, this.engage});

  @override
  State<ExpeditionCard> createState() => _ExpeditionCardState();
}

class _ExpeditionCardState extends State<ExpeditionCard> {



  Future<void> expeditionFunctionsState(context, UserBase user)async {
    if (widget.expedition.accepted) {
      if (widget.expedition.completed) {
        var uuid = Uuid();
        String expeditionId = 'E${uuid.v4().substring(0, 8)}';

        ExpeditionModel expedition = ExpeditionModel(
          dateFormat(DateTime.now()),
          expeditionId,
          widget.expedition.packages,
          true,
          widget.expedition.equipment,
          widget.expedition.retireAddress,
          widget.expedition.destinationAddress,
          widget.expedition.offer,
          widget.expedition.owner,
          false,
          false,
          false,
          false,
          widget.expedition.senderRole,
          widget.expedition.receiver,
          widget.expedition.sender,
        );
        Provider.of<AppState>(context, listen: false).addNewExpedition(expedition);
        Provider.of<AppState>(context, listen: false).deleteExpedition(widget.expedition);
        widget.setExpedition(widget.expedition);
      } else {
        if (widget.expedition.paid) {
        } else {
          final payment = await StripePaymentService().initPaymentSheet(
            widget.expedition.offer,
            'EUR',
          );

          await FirebaseDatabase().setExpeditionPaid(
            widget.expedition.id,
            user,
            widget.expedition.trackDriverId,
          );

          final driverId = widget.expedition.trackDriverId;

          if (driverId != null) {
            TruckDriverModel driver = await FirebaseDatabase().getTruckDriverById(driverId);
            await sendNotification(driver.token, '${user.name} ${user.lastName}', AppLocalizations.of(context).translate("expeditionPaid"), "acceptation", widget.expedition.id, widget.expedition.track);
          }

        }
      }
    }else {
      if (widget.expedition.paid) {
      } else {
        Provider.of<AppState>(context, listen: false).deleteExpedition(widget.expedition);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;
    return InkWell(
      onTap: () {
        widget.setExpedition(widget.expedition);
      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)
                    .translate("warning"),
                style: blueText16w700,
              ),
              content: Text(
                AppLocalizations.of(context)
                    .translate("expeditionDeleting"),
                style: blackText14,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {

                    await FirebaseDatabase().deleteExpedition(user.id, widget.expedition.id, false);
                  },
                  child: Text(AppLocalizations.of(context)
                      .translate("delete")),
                ),
              ],
            );
          },
        );
      },
      child: Container(
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
                      widget.expedition.date,
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
                            widget.engage != null ? SizedBox() : LuckywayIconBtn(onPressed: (){
                              widget.setExpedition(widget.expedition);
                            }, backgroundColor: Colors.black, icon: 'assets/back-arrow.svg'),
                            SizedBox(width: 10,),
                            LuckywayBtn(text: AppLocalizations.of(context)
                                .translate("sendRequest"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: (){
                              widget.setExpedition(widget.expedition);
                            })
                          ],
                        ) : LuckywayBtn(
                            text: expeditionButtonState(widget.expedition, context), backgroundColor: expeditionColorState(widget.expedition, context), textStyle: whiteText14w700, icon: expeditionIconState(widget.expedition, context), onPressed: (){
                          expeditionFunctionsState(context, user);
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
      ),
    );
  }
}
