import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LuckywayBtn extends StatefulWidget {
  final Function onPressed;
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  String? icon;
  LuckywayBtn({super.key, required this.text, required this.backgroundColor, required this.textStyle, required this.onPressed, this.icon});

  @override
  State<LuckywayBtn> createState() => _LuckywayBtnState();
}

class _LuckywayBtnState extends State<LuckywayBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(widget.backgroundColor)
      ),
        onPressed: (){
          widget.onPressed();
    }, child: widget.icon != null ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          widget.icon!,
          color: Colors.white,
          height: 30,
          width: 30,
        ),
        SizedBox(width: 10,),
        Text(widget.text, style: widget.textStyle,)
      ],
    ) : Text(widget.text, style: widget.textStyle,));
  }
}
