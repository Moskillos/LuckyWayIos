import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';

import '../app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        title: AppLocalizations.of(context).translate("privacy"),
        button: SizedBox(),
        content: Column(
          children: [
            Text(AppLocalizations.of(context).translate("privacy"))
          ],
        ),
        showHeader: true,
        isNavigate: true);
  }
}
