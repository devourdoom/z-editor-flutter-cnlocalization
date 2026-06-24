import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/InitialPlantData.dart';

class InitialPlantEntryData extends PvzModel {
  InitialPlantEntryData({this.plants = const []});

  List<InitialPlantData> plants;

  factory InitialPlantEntryData.fromJson(Map<String, dynamic> json) {
    return InitialPlantEntryData(
      plants:
          (json['Plants'] as List<dynamic>?)
              ?.map((e) => InitialPlantData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Plants': plants.map((e) => e.toJson()).toList(),
  };
}
