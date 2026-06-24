import 'package:c_editor/data/pvz_models/PvzModel.dart';

class LastStandMinigamePropertiesData extends PvzModel {
  LastStandMinigamePropertiesData({
    this.startingSun = 2000,
    this.startingPlantfood = 0,
  });

  int startingSun;
  int startingPlantfood;

  factory LastStandMinigamePropertiesData.fromJson(Map<String, dynamic> json) {
    return LastStandMinigamePropertiesData(
      startingSun: json['StartingSun'] as int? ?? 2000,
      startingPlantfood: json['StartingPlantfood'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'StartingSun': startingSun,
    'StartingPlantfood': startingPlantfood,
  };
}
