

import '../database.dart';
import '../models/expedition_model.dart';
import 'mapper/expeditions_mapper.dart';

Future<List<ExpeditionModel>> handleExpeditions(expeditions) async {
  List<ExpeditionModel> expeditionList = [];
  for (var expedition in expeditions) {
    ExpeditionModel e = await FirebaseDatabase().getExpeditionWithTrack(expedition);
    expeditionList.add(e);
  }
  return expeditionList;
}

Future<List<ExpeditionModel>> handleDriverExpeditions(expeditions) async {
  List<ExpeditionModel> expeditionList = expeditionsMapper(expeditions);
  List<ExpeditionModel> expeditionNotAccepted = expeditionList.where((expedition) => expedition.accepted == false).toList();

  return expeditionNotAccepted;
}