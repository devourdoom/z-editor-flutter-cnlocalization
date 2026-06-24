import 'package:c_editor/data/pvz_models/PvzModel.dart';

class DynamicZombieGroup extends PvzModel {
  DynamicZombieGroup({
    this.pointIncrement = 0,
    this.startingPoints = 0,
    this.startingWave = 0,
    List<String>? zombiePool,
    List<int>? zombieLevel,
  }) : zombiePool = zombiePool ?? [],
       zombieLevel = zombieLevel ?? [];

  int pointIncrement;
  int startingPoints;
  int startingWave;
  List<String> zombiePool;
  List<int> zombieLevel;

  factory DynamicZombieGroup.fromJson(Map<String, dynamic> json) {
    return DynamicZombieGroup(
      pointIncrement: json['PointIncrementPerWave'] as int? ?? 0,
      startingPoints: json['StartingPoints'] as int? ?? 0,
      startingWave: json['StartingWave'] as int? ?? 0,
      zombiePool: (json['ZombiePool'] as List<dynamic>?)?.cast<String>() ?? [],
      zombieLevel: (json['ZombieLevel'] as List<dynamic>?)?.cast<int>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'PointIncrementPerWave': pointIncrement,
    'StartingPoints': startingPoints,
    'StartingWave': startingWave,
    'ZombiePool': zombiePool,
    'ZombieLevel': zombieLevel,
  };
}
