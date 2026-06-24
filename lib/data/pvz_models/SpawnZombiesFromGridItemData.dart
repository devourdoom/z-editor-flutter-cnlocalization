import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ZombieSpawnData.dart';

class SpawnZombiesFromGridItemData extends PvzModel {
  SpawnZombiesFromGridItemData({
    this.waveStartMessage,
    this.zombieSpawnWaitTime = 0,
    this.gridTypes = const [],
    this.zombies = const [],
  });

  String? waveStartMessage;
  int zombieSpawnWaitTime;
  List<String> gridTypes;
  List<ZombieSpawnData> zombies;

  factory SpawnZombiesFromGridItemData.fromJson(Map<String, dynamic> json) {
    return SpawnZombiesFromGridItemData(
      waveStartMessage: json['WaveStartMessage'] as String?,
      zombieSpawnWaitTime: json['ZombieSpawnWaitTime'] as int? ?? 0,
      gridTypes: (json['GridTypes'] as List<dynamic>?)?.cast<String>() ?? [],
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
      'ZombieSpawnWaitTime': zombieSpawnWaitTime,
      'GridTypes': gridTypes,
      'Zombies': zombies.map((e) => e.toJson()).toList(),
    };
    if (waveStartMessage != null) data['WaveStartMessage'] = waveStartMessage;
    return data;
  }
}
