import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

Widget preferencesItem(String infoTitle, String info, Widget action, bool modify , Function setModify, String icon){
  return modify ? action : Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: primaryBlue),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(infoTitle, style: blackText14w700,),
              Text(info, style: blueText14w700,)
            ],
          ),
          InkWell(
            onTap: (){
               setModify();
            } ,
            child: SvgPicture.asset(
              icon,
              color: Colors.black,
              height: 30,
              width: 30,
            ),
          )
        ],
      ),
    ),
  );
}