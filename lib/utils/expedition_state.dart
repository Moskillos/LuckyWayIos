import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/costants/global_color.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/payment_page.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';

String expeditionState(ExpeditionModel expedition, BuildContext context) {
  if (expedition.accepted) {
    if (expedition.completed) {
      return AppLocalizations.of(context).translate("delivered");
    } else {
      if (expedition.paid) {
        return AppLocalizations.of(context).translate("outgoing"); // Aggiunto return
      } else {
        return AppLocalizations.of(context).translate("accepted");
      }
    }
  } else {
    if (expedition.paid) {
      return AppLocalizations.of(context).translate("paid");
    } else {
      return AppLocalizations.of(context).translate("inList");
    }
  }
}

String expeditionInfoState(ExpeditionModel expedition, context){
  if (expedition.accepted) {
    if (expedition.completed) {
      return AppLocalizations.of(context).translate("deliveredInfo");
    } else {
      if (expedition.paid) {
        return AppLocalizations.of(context).translate("outgoingInfo"); // Aggiunto return
      } else {
        return AppLocalizations.of(context).translate("acceptedInfo");
      }
    }
  } else {
    if (expedition.paid) {
      return AppLocalizations.of(context).translate("paidInfo");
    } else {
      return AppLocalizations.of(context).translate("inListInfo");
    }
  }
}

String expeditionButtonState(ExpeditionModel expedition, context){
  if (expedition.accepted) {
    if (expedition.completed) {
      return AppLocalizations.of(context).translate("deliveredBtn");
    } else {
      if (expedition.paid) {
        return AppLocalizations.of(context).translate("outgoingBtn"); // Aggiunto return
      } else {
        return AppLocalizations.of(context).translate("acceptedBtn");
      }
    }
  } else {
    if (expedition.paid) {
      return AppLocalizations.of(context).translate("inListBtn");
    } else {
      return AppLocalizations.of(context).translate("inListBtn");
    }
  }
}

String expeditionIconState(ExpeditionModel expedition, context){
  if (expedition.accepted) {
    if (expedition.completed) {
      return AppLocalizations.of(context).translate("assets/arrow-around.svg");
    } else {
      if (expedition.paid) {
        return AppLocalizations.of(context).translate("assets/hourglass.svg"); // Aggiunto return
      } else {
        return AppLocalizations.of(context).translate("assets/eur.svg");
      }
    }
  } else {
    if (expedition.paid) {
      return AppLocalizations.of(context).translate("assets/delete.svg");
    } else {
      return AppLocalizations.of(context).translate("assets/delete.svg");
    }
  }
}

String expeditionMainIconState(ExpeditionModel expedition, context){
  if (expedition.accepted) {
    if (expedition.completed) {
      return AppLocalizations.of(context).translate("assets/arrow-around.svg");
    } else {
      if (expedition.paid) {
        return AppLocalizations.of(context).translate("assets/hourglass.svg"); // Aggiunto return
      } else {
        return AppLocalizations.of(context).translate("assets/eur.svg");
      }
    }
  } else {
    if (expedition.paid) {
      return AppLocalizations.of(context).translate("assets/delete.svg");
    } else {
      return AppLocalizations.of(context).translate("assets/minus-circle.svg");
    }
  }
}


Color expeditionColorState(ExpeditionModel expedition, context){
  if (expedition.accepted) {
    if (expedition.completed) {
      return backGroundColor;
    } else {
      if (expedition.paid) {
        return mainGreen; // Aggiunto return
      } else {
        return Colors.yellow;
      }
    }
  } else {
    if (expedition.paid) {
      return mainGreen;
    } else {
      return grey;
    }
  }
}

