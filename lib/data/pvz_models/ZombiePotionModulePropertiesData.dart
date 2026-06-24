import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/PotionSpawnTimerData.dart';

class ZombiePotionModulePropertiesData extends PvzModel {
  ZombiePotionModulePropertiesData({
    this.initialPotionCount = 10,
    this.maxPotionCount = 60,
    PotionSpawnTimerData? potionSpawnTimer,
    this.potionTypes = const [],
  }) : potionSpawnTimer = potionSpawnTimer ?? PotionSpawnTimerData();

  int initialPotionCount;
  int maxPotionCount;
  PotionSpawnTimerData potionSpawnTimer;
  List<String> potionTypes;

  factory ZombiePotionModulePropertiesData.fromJson(Map<String, dynamic> json) {
    return ZombiePotionModulePropertiesData(
      initialPotionCount: json['InitialPotionCount'] as int? ?? 10,
      maxPotionCount: json['MaxPotionCount'] as int? ?? 60,
      potionSpawnTimer: PotionSpawnTimerData.fromJson(
        json['PotionSpawnTimer'] as Map<String, dynamic>? ?? {},
      ),
      potionTypes:
          (json['PotionTypes'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'InitialPotionCount': initialPotionCount,
    'MaxPotionCount': maxPotionCount,
    'PotionSpawnTimer': potionSpawnTimer.toJson(),
    'PotionTypes': potionTypes,
  };
}
