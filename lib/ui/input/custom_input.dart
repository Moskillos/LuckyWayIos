import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class CustomInput extends StatefulWidget {
  String? label;
  final String placeholder;
  IconData? icon;
  bool? isPassword;
  final Function updateValue;
  TextEditingController? controller;
  TextStyle? textStyle;
  String? extraBtn;
  Function? extraFunction;
  bool? loader;
  double? padding;
  Color? backgroundInputColor;
  TextInputType? textInputType;
  IconData? searchIcon;
  int? minLines;
  int? maxLines;
  bool? disable;

  CustomInput({super.key, required this.placeholder,this.icon, required this.updateValue,this.textStyle, this.controller, this.extraBtn, this.extraFunction, this.isPassword, this.loader, this.padding, this.backgroundInputColor,this.textInputType, this.searchIcon, this.label, this.minLines, this.maxLines, this.disable});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> with SingleTickerProviderStateMixin{
  bool hidePassword = true;
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Durata del movimento circolare
    )..repeat(); // Ripeti l'animazione all'infinito

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        if(widget.label != null)Row(
          children: [
            SizedBox(width: 30,),
            Text(widget.label!, style: blackText14w700,),
          ],
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 20,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: primaryBlue, width: 1),
              borderRadius: BorderRadius.circular(50),
            color: widget.backgroundInputColor
          ),
          width: MediaQuery.of(context).size.width - 20,
          child: Padding(
            padding: EdgeInsets.all(widget.padding ?? 8.0),
            child: Row(
              children: [
                widget.icon != null ? Icon(widget.icon, size: 30, color: grey,) : SizedBox(),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    style: blueText14w700,
                    enabled: widget.disable,
                    obscureText: hidePassword && widget.isPassword == true,
                    controller: widget.controller,
                    keyboardType: widget.textInputType,
                    minLines: (widget.isPassword == true) ? 1 : widget.minLines,
                    maxLines: (widget.isPassword == true) ? 1 : widget.maxLines,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.placeholder,
                      hintStyle: greyText18
                    ),
                    onChanged: (value) =>  widget.updateValue(value),
                    validator: (value) {
                      if(widget.placeholder == 'numero civico'){
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un valore';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Inserisci un numero';
                        }
                        return null;
                      }
                      if(widget.placeholder == 'CAP'){
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un valore';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Inserisci un numero';
                        }
                        if (double.tryParse(value)!.toInt().toString().length > 5) {
                          return 'Non puoi inserire più di 5 valori';
                        }
                        if (double.tryParse(value)!.toInt().toString().length < 5) {
                          return 'Non puoi inserire meno di 5 valori';
                        }
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Inserisci un valore';
                      }


                      return null;
                    },
                  ),
                ),
                widget.isPassword != null ? InkWell(
                    onTap: (){
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: SvgPicture.asset(
                      hidePassword ? 'assets/eye-close.svg' : 'assets/eye.svg',
                      height: 30,
                      width: 30,
                    )) : const SizedBox(),
                widget.extraBtn != null ? InkWell(
                  onTap: (){
                    widget.extraFunction!();
                  },
                  child: widget.loader != null && widget.loader == false ?  Container(
                      padding: EdgeInsets.all(widget.padding ?? 10),
                      decoration: BoxDecoration(
                          color: mainGreen,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(widget.extraBtn!, style: blackText14,)
                  ) : const SpinKitCircle(size: 50, color: Colors.black,),
                ) : const SizedBox(),
          widget.searchIcon != null
              ? InkWell(
            onTap: () {
              widget.extraFunction!();
            },
            child: widget.loader != null && widget.loader == false
                ? Icon(widget.searchIcon, size: 25, color: Colors.black)
                : _animation == null
                ? const SpinKitCircle(size: 50, color: Colors.black)
                : AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                double radius = 5; // Raggio del cerchio
                return Transform.translate(
                  offset: Offset(radius * cos(_animation!.value), radius * sin(_animation!.value)),
                  child: Icon(widget.searchIcon, size: 25, color: Colors.black),
                );
              },
            ),
          )
              : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
