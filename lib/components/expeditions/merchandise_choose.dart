import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../models/merchandise_model.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/custom_divider.dart';

class MerchandiseChoose extends StatefulWidget {
  final String merchandiseSelected;
  final Function setMerchadiseSelected;
  const MerchandiseChoose({super.key, required this.merchandiseSelected, required this.setMerchadiseSelected});

  @override
  State<MerchandiseChoose> createState() => _MerchandiseChooseState();
}

class _MerchandiseChooseState extends State<MerchandiseChoose> {
  List<MerchandiseModel> merchandises = [

  ];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      merchandises = [
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("pallet"), 'pallet'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("boxes"), 'boxes'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("auto"), 'auto'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("moto"), 'moto'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("nautical"), 'nautical'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("agriculturalMachinery"), 'agricultural'),
        MerchandiseModel('assets/cube.svg', AppLocalizations.of(context).translate("other"), 'other'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          CustomDivider(color: Colors.black,),
          Column(
            children: List.generate(merchandises.length, (index) => SelectorWidgetCard(border: true,setUserPurpose: widget.setMerchadiseSelected, type: merchandises[index].value, image: merchandises[index].image, text: merchandises[index].title, userPurpose: widget.merchandiseSelected)),
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }
}
