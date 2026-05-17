import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../costants/text_style.dart';
import '../../ui/input/custom_input.dart';

class ArticlesDimensions extends StatefulWidget {
  final Function addArticle;
  final TextEditingController weightArticleController;
  final TextEditingController heightArticleController;
  final TextEditingController lengthArticleController;
  final TextEditingController widthArticleController;
  final TextEditingController nameArticleController;
  final Function setNameArticle;
  final Function setWidthArticle;
  final Function setHeightArticle;
  final Function setWeightArticle;
  final Function setLengthArticle;
  const ArticlesDimensions(
      {
        super.key,
        required this.addArticle,
        required this.weightArticleController,
        required this.heightArticleController,
        required this.lengthArticleController,
        required this.widthArticleController,
        required this.nameArticleController,
        required this.setNameArticle,
        required this.setWidthArticle,
        required this.setHeightArticle,
        required this.setWeightArticle,
        required this.setLengthArticle,

      }
      );

  @override
  State<ArticlesDimensions> createState() => _ArticlesDimensionsState();
}

class _ArticlesDimensionsState extends State<ArticlesDimensions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context).translate("insertArticleDimensions"), style: greyText18),
          SizedBox(height: 40,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLabel"), updateValue: widget.setNameArticle, label: AppLocalizations.of(context).translate("articleName"), controller: widget.nameArticleController,),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertWidth"), updateValue: widget.setWidthArticle, label: AppLocalizations.of(context).translate("articleFeatures"), controller: widget.widthArticleController),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertLength"), updateValue: widget.setLengthArticle, controller: widget.lengthArticleController),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertHeight"), updateValue: widget.setHeightArticle, controller: widget.heightArticleController),
          SizedBox(height: 20,),
          CustomInput(placeholder: AppLocalizations.of(context).translate("insertWeight"), updateValue: widget.setWeightArticle, controller: widget.weightArticleController),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
