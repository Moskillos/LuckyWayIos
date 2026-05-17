import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../ui/input/custom_input.dart';

class SearchBanner extends StatefulWidget {
  final Function updateCity;
  final Function setMenuItemSelected;
  final String menuItemSelected;
  const SearchBanner({super.key, required this.updateCity, required this.setMenuItemSelected, required this.menuItemSelected});

  @override
  State<SearchBanner> createState() => _SearchBannerState();
}

class _SearchBannerState extends State<SearchBanner> {
  final _formSignInKey = GlobalKey<FormState>();
  bool loader = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Container(
        //     color: Colors.blue,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Row(
        //         children: [
        //           SizedBox(width: 10,),
        //           Container(
        //             width: 250,
        //             height: 60,
        //             child: Form(
        //                 key: _formSignInKey,
        //                 child: Row(
        //                   children: [
        //                     Expanded(
        //                       child: CustomInput(
        //                         placeholder: AppLocalizations.of(context).translate("insertCity"),
        //                         updateValue: widget.updateCity,
        //                         backgroundInputColor: Colors.white,
        //                         loader: loader,),
        //                     ),
        //
        //                   ],
        //                 )),
        //           ),
        //           Row(
        //             children: List.generate(merchandisesMenu(context).length, (index) => InkWell(
        //               onTap: (){
        //                 setState(() {
        //                   widget.setMenuItemSelected(merchandisesMenu(context)[index].value);
        //                 });
        //               },
        //               child: Container(
        //                 decoration: widget.menuItemSelected == merchandisesMenu(context)[index].value ? BoxDecoration(
        //                   border: Border.all(color: Colors.white, width: 1),
        //
        //                 ) : BoxDecoration(
        //                   color: Colors.blue,
        //                 ),
        //
        //                 padding: EdgeInsets.all(10),
        //                 child: Text(merchandisesMenu(context)[index].title, style: blackText14,),
        //               ),
        //             )),
        //           )
        //         ] ,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
