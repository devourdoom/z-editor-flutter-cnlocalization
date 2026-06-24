import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/GravestonePoolItem.dart';
import 'package:c_editor/data/pvz_models/LocationData.dart';

class SpawnGraveStonesData extends PvzModel {
  SpawnGraveStonesData({
    this.gravestonePool = const [],
    this.spawnPositionsPool = const [],
  });

  List<GravestonePoolItem> gravestonePool;
  List<LocationData> spawnPositionsPool;

  factory SpawnGraveStonesData.fromJson(Map<String, dynamic> json) {
    return SpawnGraveStonesData(
      gravestonePool:
          (json['GravestonePool'] as List<dynamic>?)
              ?.map(
                (e) => GravestonePoolItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      spawnPositionsPool:
          (json['SpawnPositionsPool'] as List<dynamic>?)
              ?.map((e) => LocationData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'GravestonePool': gravestonePool.map((e) => e.toJson()).toList(),
    'SpawnPositionsPool': spawnPositionsPool.map((e) => e.toJson()).toList(),
  };
}
