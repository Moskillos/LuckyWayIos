import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/expedition_model.dart';
import '../../ui/input/custom_labeled_switch.dart';
import 'expedition_list.dart';
import 'expedition_map.dart';

class DriverExpeditionFound extends StatefulWidget {
  final String value;
  final Function onChanged;
  final String firstItem;
  final String secondItem;
  final String city;
  final CollectionReference<Map<String, dynamic>> expeditionsCollection;
  final Function setExpedition;
  final ExpeditionModel? selectedExpedition;
  final Function changePage;
  DriverExpeditionFound({super.key, required this.value, required this.onChanged, required this.firstItem, required this.secondItem, required this.city,required this.expeditionsCollection, required this.setExpedition, this.selectedExpedition, required this.changePage});

  @override
  State<DriverExpeditionFound> createState() => _DriverExpeditionFoundState();
}

class _DriverExpeditionFoundState extends State<DriverExpeditionFound> {
  bool _mapIsBeingTouched = false;

  void onPointerDown(){
    setState(() {
      _mapIsBeingTouched = true;
    });
  }

  void onPointerUp(){
    setState(() {
      _mapIsBeingTouched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        physics: _mapIsBeingTouched
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 20,),
          CustomLabeledSwitch(
              onChanged: widget.onChanged,
              value: widget.value,
              firstItem: widget.firstItem,
              secondItem: widget.secondItem),
          widget.value == widget.firstItem ? ExpeditionList(
            setExpedition: widget.setExpedition,
            city: widget.city,
            expeditionsCollection: widget.expeditionsCollection,
            selectedExpedition: widget.selectedExpedition,
            changePage: widget.changePage,
          ) : ExpeditionMap(city: widget.city, onPointerDown: onPointerDown, onPointerUp: onPointerUp, setExpedition: widget.setExpedition, changePage: widget.changePage,)
        ],
      ),
    );
  }
}
