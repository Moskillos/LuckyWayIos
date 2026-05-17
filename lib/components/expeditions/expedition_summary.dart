import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/package_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../utils/date_format.dart';

class ExpeditionSummary extends StatefulWidget {
  final String retireCity;
  final String retireStreet;
  final String retireNumber;
  final String retireCap;
  final String retireProvince;
  final String destinationCity;
  final String destinationStreet;
  final String destinationNumber;
  final String destinationCap;
  final String destinationProvince;
  final String senderName;
  final String recipientName;
  final String senderPhone;
  final String recipientPhone;
  final String senderEmail;
  final String recipientEmail;
  final String offer;
  final List<PackageModel> articles;
  final String merchandise;
  final bool flammable;
  final bool fragile;
  final String senderRole;
  final Function changePage;

  const ExpeditionSummary(
      {super.key,
      required this.retireCity,
      required this.destinationCity,
      required this.senderName,
      required this.articles,
        required this.retireStreet,
        required this.retireNumber,
        required this.retireCap,
        required this.retireProvince,
        required this.destinationStreet,
        required this.destinationNumber,
        required this.destinationCap,
        required this.destinationProvince,
        required this.recipientName, 
        required this.offer,
        required this.merchandise,
        required this.flammable,
        required this.fragile,
        required this.senderRole,
        required this.senderPhone,
        required this.recipientPhone,
        required this.senderEmail,
        required this.recipientEmail,
        required this.changePage
      });

  @override
  State<ExpeditionSummary> createState() => _ExpeditionSummaryState();
}

class _ExpeditionSummaryState extends State<ExpeditionSummary> {

  Widget addressRender(String title, String name, String street, String number, String cap, String city, String province){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth, // Prende tutta la larghezza disponibile
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: blackText14,
              ),
              Text(
                name,
                style: blackText14w700,
              ),
              Text(
                '$street, $number, $cap, $city',
                style: blackText14w700,
              ),
              Text(
                province,
                style: blackText14w700,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 30),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: primaryBlue, width: 1),
            borderRadius: BorderRadius.circular(20)
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              Text('${widget.retireCity} - ${widget.destinationCity}',
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
              Text(widget.senderName, style: blackText14w700),
            ]),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate("numberArticles"),
                  style: blackText14,
                ),
                Text(widget.articles.length.toString(), style: blackText14w700),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate(widget.articles.length > 1 ? "nameArticles" : "nameArticle"),
                  style: blackText14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      widget.articles.length,
                      (index) => Text(widget.articles[index].name,
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
                  AppLocalizations.of(context).translate("dimensions"),
                  style: blackText14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      widget.articles.length,
                      (index) => Text('${widget.articles[index].length}x${widget.articles[index].width}x${widget.articles[index].height} cm - ${widget.articles[index].weight}Kg',
                          style: blackText14w700)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            addressRender(AppLocalizations.of(context).translate("retireAddress"), widget.senderName, widget.retireStreet, widget.retireNumber, widget.retireCap, widget.retireCity, widget.retireProvince),
            SizedBox(
              height: 10,
            ),
            addressRender(AppLocalizations.of(context).translate("destinationAddress"), widget.recipientName, widget.destinationStreet, widget.destinationNumber, widget.destinationCap, widget.destinationCity, widget.destinationProvince),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate("offer2"), style: blackText14,),
                Text('${widget.offer},00€', style: blackText14w700,)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LuckywayBtn(text: AppLocalizations.of(context).translate("confirm"), backgroundColor: Colors.black, textStyle: whiteText14w700, onPressed: (){
                  widget.changePage();

                })
              ],
            )
          ],
        )),
      ),
    );
  }
}
