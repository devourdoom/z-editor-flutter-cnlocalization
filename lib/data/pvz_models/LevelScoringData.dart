import 'package:c_editor/data/pvz_models/PvzModel.dart';

class LevelScoringData extends PvzModel {
  LevelScoringData({
    this.plantBonusMultiplier = 0.0,
    this.plantBonuses = const [],
    this.scoringRulesType = 'NoMultiplier',
    this.startingPlantfood = 0,
  });

  double plantBonusMultiplier;
  List<String> plantBonuses;
  String scoringRulesType;
  int startingPlantfood;

  factory LevelScoringData.fromJson(Map<String, dynamic> json) {
    return LevelScoringData(
      plantBonusMultiplier:
          (json['PlantBonusMultiplier'] as num?)?.toDouble() ?? 0.0,
      plantBonuses:
          (json['PlantBonuses'] as List<dynamic>?)?.cast<String>() ?? [],
      scoringRulesType: json['ScoringRulesType'] as String? ?? 'NoMultiplier',
      startingPlantfood: json['StartingPlantfood'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'PlantBonusMultiplier': plantBonusMultiplier,
    'PlantBonuses': plantBonuses,
    'ScoringRulesType': scoringRulesType,
    'StartingPlantfood': startingPlantfood,
  };
}
