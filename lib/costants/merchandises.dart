import 'package:lucky_way_ios/models/merchandise_model.dart';

import '../app_localizations.dart';

List<MerchandiseModel> merchandises(context){
  return [
    MerchandiseModel('https://i.postimg.cc/Z54VkZc3/box.png',
        AppLocalizations.of(context).translate("bigBox"),
        "bigBox"),
    MerchandiseModel(
        'https://i.postimg.cc/8P0Xgsk9/download-removebg-preview.png',
        AppLocalizations.of(context).translate("footboard"),
        "footboard"),
    MerchandiseModel('https://i.postimg.cc/Jh49RSVd/moto.png',
        AppLocalizations.of(context).translate("moto"),
        "moto"),
    MerchandiseModel('https://i.postimg.cc/wv8rmmMC/goods.png',
        AppLocalizations.of(context).translate("variousGoods"),
        "variousGoods"),
    MerchandiseModel('https://i.postimg.cc/4d6Sbxhm/trattore.png',
        AppLocalizations.of(context).translate("largeGoods"),
        "largeGoods"),
  ];
}

List<MerchandiseModel> merchandisesMenu(context){
  return [
    MerchandiseModel('https://i.postimg.cc/cLhT0j9z/auto.png',
        AppLocalizations.of(context).translate("car"),
        "car"),
    MerchandiseModel('https://i.postimg.cc/Z54VkZc3/box.png',
        AppLocalizations.of(context).translate("bigBox"),
        "bigBox"),
    MerchandiseModel(
        'https://i.postimg.cc/8P0Xgsk9/download-removebg-preview.png',
        AppLocalizations.of(context).translate("footboard"),
        "footboard"),
    MerchandiseModel('https://i.postimg.cc/Jh49RSVd/moto.png',
        AppLocalizations.of(context).translate("moto"),
        "moto"),
    MerchandiseModel('https://i.postimg.cc/wv8rmmMC/goods.png',
        AppLocalizations.of(context).translate("variousGoods"),
        "variousGoods"),
    MerchandiseModel('https://i.postimg.cc/4d6Sbxhm/trattore.png',
        AppLocalizations.of(context).translate("largeGoods"),
        "largeGoods"),
  ];
}