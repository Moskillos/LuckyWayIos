import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../models/package_model.dart';
import '../../ui/cards/selector_widget_card_2.dart';

class PublishExpedition extends StatefulWidget {
  final List<PackageModel> articles;
  final Function goToNewArticle;
  const PublishExpedition({super.key,required this.articles, required this.goToNewArticle});

  @override
  State<PublishExpedition> createState() => _PublishExpeditionState();
}

class _PublishExpeditionState extends State<PublishExpedition> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        children: [
          Column(
            children: List.generate(widget.articles.length, (index) => SelectorWidgetCard2(image: 'assets/cube.svg', merchandise: widget.articles[index].merchandise, articleName: widget.articles[index].name,)),
          )
          ,
          SelectorWidgetCard2(image: 'assets/plus.svg', action: widget.goToNewArticle, actionText: AppLocalizations.of(context).translate("addANewArticle"),)
        ],
      ),
    );
  }
}
