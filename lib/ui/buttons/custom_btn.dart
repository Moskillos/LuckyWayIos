
import 'package:flutter/material.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class CustomBtn extends StatelessWidget {
  final Function onPressed;
  final String text;
  const CustomBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2)
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text(text, style: blackText14,),
          ))),
    );

  }
}
