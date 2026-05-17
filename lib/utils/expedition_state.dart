import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../costants/global_color.dart';
import '../models/expedition_model.dart';

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
        return AppLocalizations.of(context).translate("assets/chat.svg"); // Aggiunto return
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
        return AppLocalizations.of(context).translate("assets/chat.svg"); // Aggiunto return
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
      return grey;
    } else {
      if (expedition.paid) {
        return grey; // Aggiunto return
      } else {
        return grey;
      }
    }
  } else {
    if (expedition.paid) {
      return grey;
    } else {
      return grey;
    }
  }
}

