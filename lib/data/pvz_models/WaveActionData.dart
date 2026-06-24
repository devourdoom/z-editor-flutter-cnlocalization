import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ZombieSpawnData.dart';

class WaveActionData extends PvzModel {
  WaveActionData({
    this.notificationEvents,
    this.additionalPlantFood,
    this.spawnPlantName,
    this.zombies = const [],
  });

  List<String>? notificationEvents;
  int? additionalPlantFood;
  List<String>? spawnPlantName;
  List<ZombieSpawnData> zombies;

  factory WaveActionData.fromJson(Map<String, dynamic> json) {
    return WaveActionData(
      notificationEvents: (json['NotificationEvents'] as List<dynamic>?)
          ?.cast<String>(),
      additionalPlantFood: json['AdditionalPlantfood'] as int?,
      spawnPlantName: (json['SpawnPlantName'] as List<dynamic>?)
          ?.cast<String>(),
      zombies:
          (json['Zombies'] as List<dynamic>?)?.map((e) {
            if (e is Map<String, dynamic>) {
              return ZombieSpawnData.fromJson(e);
            }
            if (e is String) {
              return ZombieSpawnData(type: e);
            }
            return ZombieSpawnData();
          }).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'Zombies': zombies.map((e) => e.toJson()).toList(),
    };
    if (notificationEvents != null) {
      data['NotificationEvents'] = notificationEvents;
    }
    if (additionalPlantFood != null) {
      data['AdditionalPlantfood'] = additionalPlantFood;
    }
    if (spawnPlantName != null) {
      data['SpawnPlantName'] = spawnPlantName;
    }
    return data;
  }
}
