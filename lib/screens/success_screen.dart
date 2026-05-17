import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/costants/text_style.dart';

class SuccessScreen extends StatefulWidget {
  final String title;
  String? description;
  SuccessScreen({super.key, required this.title, this.description});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: mainGreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Allinea il contenuto al centro
                children: [
                  SvgPicture.asset(
                    'assets/check.svg',
                    color: Colors.black,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20), // Spazio tra icona e testo
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: Text(
                      widget.title,
                      style: blackText28w700,
                      textAlign: TextAlign.center, // Allinea il testo al centro
                    ),
                  ),
                  if(widget.description != null)Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: Text(
                      widget.description!,
                      style: blackText14w700,
                      textAlign: TextAlign.center, // Allinea il testo al centro
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      );
  }
}
