import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
// import 'package:lucky_way_ios/revolut_service.dart';
// import 'package:lucky_way_ios/stripe_service.dart';
import 'package:lucky_way_ios/ui/buttons/luckyway_btn.dart';
import 'package:lucky_way_ios/ui/custom_divider.dart';
import 'package:lucky_way_ios/utils/amount_converter.dart';

import '../../app_localizations.dart';
import 'new_expedition_screen.dart';

class Home extends StatefulWidget {
  final Function goToTrackPage;
  const Home({super.key, required this.goToTrackPage});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Widget itemRender(String icon, String text, Function action){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: InkWell(
        onTap: (){
          action();
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black
              ),
              child: SvgPicture.asset(
                icon,
                color: Colors.white,
                height: 30,
                width: 30,
              ),
            ),
            SizedBox(width: 10,),
            Text(text, style: blackText14w700,)
          ],
        ),
      ),
    );
  }

  void goToNewExpedition(){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => NewExpeditionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return LuckyWayLayout(
      isNavigate: false,
        title: AppLocalizations.of(context).translate("welcomeToYourDashboard"),
        button: SizedBox(),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              itemRender('assets/plus.svg', AppLocalizations.of(context).translate("addAExpedition"), goToNewExpedition),

              CustomDivider(color: primaryBlue,),
              itemRender('assets/search.svg', AppLocalizations.of(context).translate("lookForATrack"), widget.goToTrackPage),
              // InkWell(
              //   onTap: ()async{
              //     String amount = "12.30";
              //
              //     int stripePayment = amountConverter(amount);
              //     double platformFee = (double.parse(amount) * 12) / 100;
              //     double driverPayout = double.parse(amount) - platformFee;
              //
              //     print(driverPayout);
              //     String jwt = RevolutService().generateJWTAssertion("");
              //     await StripePaymentService().initPaymentSheet(stripePayment, 'EUR')
              //         .then((paymentIntentId) async => await RevolutService().getAccessToken())
              //         .then((String value) => RevolutService().createCounterParty("Mario", "Rossastro","GB33BUKB20201555555555", value))
              //         .then((value) => RevolutService().driverPayment(value, driverPayout));
              //   },
              //   child: Text('dsada'),
              // )
            ],
          ),
        ), showHeader: true,);

  }
}