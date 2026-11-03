import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/cards/selector_widget_card.dart';
import '../../ui/custom_divider.dart';

class SenderReceiverChooseWidget extends StatefulWidget {
  final String userRole;
  final Function setUserRole;
  const SenderReceiverChooseWidget({super.key, required this.userRole, required this.setUserRole});

  @override
  State<SenderReceiverChooseWidget> createState() => _SenderReceiverChooseWidgetState();
}

class _SenderReceiverChooseWidgetState extends State<SenderReceiverChooseWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate("senderOrReceiver"), style: greyText18),
          SizedBox(height: 40,),
          CustomDivider(),
          SelectorWidgetCard(setUserPurpose: widget.setUserRole, type: 'sender', image: 'assets/cube.svg', text: AppLocalizations.of(context).translate("iAmSender"), userPurpose: widget.userRole,),
          CustomDivider(),
          SelectorWidgetCard(setUserPurpose: widget.setUserRole, type: 'recipient', image: 'assets/cube.svg', text: AppLocalizations.of(context).translate("iAmRecipient"), userPurpose: widget.userRole,),
          CustomDivider(),
        ],
      ),
    );
  }
}
