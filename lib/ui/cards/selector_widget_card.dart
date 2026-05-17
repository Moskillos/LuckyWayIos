import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../costants/text_style.dart';

class SelectorWidgetCard extends StatefulWidget {
  final Function setUserPurpose;
  final String type;
  final String image;
  final String text;
  final String userPurpose;
  bool? border;
  Function? truckSelector;

  SelectorWidgetCard({super.key, required this.setUserPurpose, required this.type, required this.image, required this.text, required this.userPurpose, this.border, this.truckSelector});

  @override
  State<SelectorWidgetCard> createState() => _SelectorWidgetCardState();
}

class _SelectorWidgetCardState extends State<SelectorWidgetCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.setUserPurpose(widget.type);
        if(widget.truckSelector != null){
          widget.truckSelector!();
        }

      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
          border: widget.border != null ? Border(bottom: BorderSide(width: 1, color:  Colors.black)) : null
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Flexible(child: Text(widget.text, style: widget.userPurpose == widget.type ? blueText14w700 : blackText14w700,)),
                  ],
                ),
              ),

              widget.userPurpose == widget.type ? SizedBox(width: 20,child: Icon(Icons.check)): SizedBox(width: 20, )
            ],
          ),
        ),
      ),
    );
  }
}
