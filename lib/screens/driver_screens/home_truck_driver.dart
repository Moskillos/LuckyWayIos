import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/components/home/search_banner.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/driver_screens/new_track_screen.dart';
import 'package:lucky_way_ios/utils/mapper/expeditions_mapper.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../store/app_state.dart';
// import '../../stripe_service.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';

class HomeTruckDriver extends StatefulWidget {
  final Function goToExpeditionPage;
  const HomeTruckDriver({super.key, required this.goToExpeditionPage});

  @override
  State<HomeTruckDriver> createState() => _HomeTruckDriverState();
}

class _HomeTruckDriverState extends State<HomeTruckDriver> {
  String city = '';
  String menuItemSelected = '';
  List<ExpeditionModel> filtredExpeditions = [];
  List<ExpeditionModel> expeditionsNAccepted = [];

  final CollectionReference<Map<String, dynamic>> _expeditionsCollection = FirebaseFirestore.instance.collection('expeditions');

  void findCity(List<ExpeditionModel> expeditions){


  }

  void updateCity(String value){
    setState(() {
      city= value;
    });
  }

  void setMenuItemSelected(String value){
    setState(() {
      menuItemSelected = value;
    });
  }

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

  void goToNewTrack(){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => NewTrackScreen()),
    );
  }

  void changeUserType(){

  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    Widget buttonRender(){
      if(user.userType.length > 1){
        for(var type in user.userType){
          if (type == user.userView){
            return LuckywayBtn(
                text: AppLocalizations.of(context).translate("passToSender"),
                backgroundColor: primaryBlue,
                textStyle: whiteText14w700,
                onPressed: changeUserType);
          } else {
            return SizedBox();
          };
        }
      } else {
        return SizedBox();
      }
      return SizedBox();
    }

    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("welcomeToYourDashboard"),
        button: SizedBox(),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              SizedBox(height: 20,),
              CustomDivider(color: primaryBlue,),
              itemRender('assets/plus.svg', AppLocalizations.of(context).translate("addATrack"), goToNewTrack),
              CustomDivider(color: primaryBlue,),
              itemRender('assets/search.svg', AppLocalizations.of(context).translate("lookForAExpedition"), widget.goToExpeditionPage),
              CustomDivider(color: primaryBlue,),
            ],
          ),
        ),
        showHeader: true,
        isNavigate: false,
        hideDivider: true,);
  }
}