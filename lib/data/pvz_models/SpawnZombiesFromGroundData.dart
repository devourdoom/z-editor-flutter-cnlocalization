import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ZombieSpawnData.dart';

class SpawnZombiesFromGroundData extends PvzModel {
  SpawnZombiesFromGroundData({
    this.columnStart = 6,
    this.columnEnd = 9,
    this.additionalPlantFood,
    this.spawnPlantName,
    this.zombies = const [],
  });

  int columnStart;
  int columnEnd;
  int? additionalPlantFood;
  List<String>? spawnPlantName;
  List<ZombieSpawnData> zombies;

  factory SpawnZombiesFromGroundData.fromJson(Map<String, dynamic> json) {
    return SpawnZombiesFromGroundData(
      columnStart: json['ColumnStart'] as int? ?? 6,
      columnEnd: json['ColumnEnd'] as int? ?? 9,
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
      'ColumnStart': columnStart,
      'ColumnEnd': columnEnd,
      'Zombies': zombies.map((e) => e.toJson()).toList(),
    };
    if (additionalPlantFood != null) {
      data['AdditionalPlantfood'] = additionalPlantFood;
    }
    if (spawnPlantName != null) {
      data['SpawnPlantName'] = spawnPlantName;
    }
    return data;
  }
}
