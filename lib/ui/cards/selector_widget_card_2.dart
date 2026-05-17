import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';

class SelectorWidgetCard2 extends StatefulWidget {
  final String image;
  String? merchandise;
  Color? border;
  String? articleName;
  Function? action;
  String? actionText;
  SelectorWidgetCard2({super.key, required this.image, this.merchandise, this.border, this.articleName, this.action, this.actionText});

  @override
  State<SelectorWidgetCard2> createState() => _SelectorWidgetCard2State();
}

class _SelectorWidgetCard2State extends State<SelectorWidgetCard2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.action != null){
          widget.action!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: widget.border != null ? Border(bottom: BorderSide(width: 1, color:  widget.border!)) : null
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: SvgPicture.asset(
                          widget.image,
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        )),
                    SizedBox(width: 10,),
                    (widget.actionText != null && widget.action != null) ? Flexible(child: Text(widget.actionText!, style: blackText14w700,)) : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.merchandise!, style: blackText14w700,),
                        Text(widget.articleName!, style: blueText14,)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
