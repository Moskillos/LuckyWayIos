
import 'package:flutter/material.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class SecondBtn extends StatelessWidget {
  final Function onPressed;
  final String text;
  Color? color;
  SecondBtn({super.key, required this.onPressed, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color ?? primaryBlue
        ),
          child: Text(text, style: blackText14,)),
    );

  }
}
