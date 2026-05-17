import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/truck_model.dart';

Widget truckCard(TruckModel truck,String infoTitle, String info, Function setSelectedTruck){
  return Container(
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
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: SvgPicture.asset(
                    'assets/truck.svg',
                    color: Colors.white,
                    height: 30,
                    width: 30,
                  )),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(infoTitle, style: blackText14w700,),
                  Text(info, style: blueText14w700,)
                ],
              )
            ],
          ),
          InkWell(
            onTap: (){
              setSelectedTruck(truck);
            } ,
            child: SvgPicture.asset(
              'assets/pencil_square.svg',
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