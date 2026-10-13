import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ZombieSpawnData.dart';

class SpawnZombiesFromGroundData extends PvzModel {
  SpawnZombiesFromGroundData({
    this.jitterOffsets,
    this.zombieSpawnPattern,
    this.fixedOffset,
    this.columnStart = 6,
    this.columnEnd = 9,
    this.additionalPlantFood,
    this.spawnPlantName,
    this.zombies = const [],
  });

  /// Optional level-local `ZombieJitterOffsets` preset.
  String? jitterOffsets;

  /// Optional spawn-pattern object applied before the position offsets.
  String? zombieSpawnPattern;

  /// When non-zero, the game adds `global zombie index * fixedOffset` to each
  /// zombie's base X coordinate. The index spans the whole event rather than
  /// resetting per row, and both [jitterOffsets] and [zombieSpawnPattern] are
  /// bypassed. Keep the original number type when round-tripping JSON.
  num? fixedOffset;
  int columnStart;
  int columnEnd;
  int? additionalPlantFood;
  List<String>? spawnPlantName;
  List<ZombieSpawnData> zombies;

  factory SpawnZombiesFromGroundData.fromJson(Map<String, dynamic> json) {
    return SpawnZombiesFromGroundData(
      jitterOffsets: json['JitterOffsets'] as String?,
      zombieSpawnPattern: json['ZombieSpawnPattern'] as String?,
      fixedOffset: json['FixedOffset'] as num?,
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

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'ColumnStart': columnStart,
      'ColumnEnd': columnEnd,
      'Zombies': zombies.map((e) => e.toJson()).toList(),
    };
    if (jitterOffsets?.isNotEmpty == true) {
      data['JitterOffsets'] = jitterOffsets;
    }
    if (zombieSpawnPattern?.isNotEmpty == true) {
      data['ZombieSpawnPattern'] = zombieSpawnPattern;
    }
    if (fixedOffset != null) {
      data['FixedOffset'] = fixedOffset;
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
