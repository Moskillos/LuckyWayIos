import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LuckywayIconBtn extends StatefulWidget {
  final Function onPressed;
  final Color backgroundColor;
  final String icon;
  const LuckywayIconBtn({super.key, required this.onPressed, required this.backgroundColor, required this.icon});

  @override
  State<LuckywayIconBtn> createState() => _LuckywayIconBtnState();
}

class _LuckywayIconBtnState extends State<LuckywayIconBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.backgroundColor)
        ),
        onPressed: (){
          widget.onPressed();
        }, child: SvgPicture.asset(
      widget.icon!,
      color: Colors.white,
      height: 30,
      width: 30,
    ));
  }
}
