
import 'package:flutter/material.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class MainBtn extends StatelessWidget {
  final Function onPressed;
  final String text;
  const MainBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              color: mainGreen,
              borderRadius: BorderRadius.circular(2)
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.only(top: 17, bottom: 17),
            child: Text(text, style: blackText14, textAlign: TextAlign.center,),
          ))),
    );

  }
}
