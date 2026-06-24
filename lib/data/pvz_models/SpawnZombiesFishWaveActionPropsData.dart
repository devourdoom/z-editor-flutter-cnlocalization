import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/FishSpawnData.dart';
import 'package:c_editor/data/pvz_models/ZombieSpawnData.dart';

class SpawnZombiesFishWaveActionPropsData extends PvzModel {
  SpawnZombiesFishWaveActionPropsData({
    this.notificationEvents,
    this.additionalPlantFood,
    this.spawnPlantName,
    this.zombies = const [],
    this.fishes = const [],
  });

  List<String>? notificationEvents;
  int? additionalPlantFood;
  List<String>? spawnPlantName;
  List<ZombieSpawnData> zombies;
  List<FishSpawnData> fishes;

  factory SpawnZombiesFishWaveActionPropsData.fromJson(
    Map<String, dynamic> json,
  ) {
    final zombiesRaw = json['Zombies'] as List<dynamic>? ?? [];
    final fishesRaw = json['Fishes'] as List<dynamic>? ?? [];
    return SpawnZombiesFishWaveActionPropsData(
      notificationEvents: (json['NotificationEvents'] as List<dynamic>?)
          ?.cast<String>(),
      additionalPlantFood: json['AdditionalPlantfood'] as int?,
      spawnPlantName: (json['SpawnPlantName'] as List<dynamic>?)
          ?.cast<String>(),
      zombies: zombiesRaw.map((e) {
        if (e is Map<String, dynamic>) return ZombieSpawnData.fromJson(e);
        if (e is String) return ZombieSpawnData(type: e);
        return ZombieSpawnData();
      }).toList(),
      fishes: fishesRaw
          .map((e) => FishSpawnData.fromJson(e as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'Zombies': zombies.map((e) => e.toJson()).toList(),
    };
    if (notificationEvents != null)
      m['NotificationEvents'] = notificationEvents;
    if (additionalPlantFood != null)
      m['AdditionalPlantfood'] = additionalPlantFood;
    if (spawnPlantName != null) m['SpawnPlantName'] = spawnPlantName;
    if (fishes.isNotEmpty) m['Fishes'] = fishes.map((e) => e.toJson()).toList();
    return m;
  }
}
