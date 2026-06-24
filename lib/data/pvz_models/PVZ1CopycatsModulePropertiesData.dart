import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PVZ1CopycatsModulePropertiesData extends PvzModel {
  PVZ1CopycatsModulePropertiesData({
    this.zombieWeight = 0.3,
    this.spawnPlantLevel = 5,
    List<String>? plantBlackList,
    List<String>? zombieWhiteList,
  }) : plantBlackList = plantBlackList ?? <String>[],
       zombieWhiteList = zombieWhiteList ?? <String>[];

  double zombieWeight;
  int spawnPlantLevel;
  List<String> plantBlackList;
  List<String> zombieWhiteList;

  factory PVZ1CopycatsModulePropertiesData.fromJson(Map<String, dynamic> json) {
    final zw = json['ZombieWeight'];
    final spl = json['SpawnPlantLevel'];
    final pbl = json['PlantBlackList'];
    final zwl = json['ZombieWhiteList'];
    return PVZ1CopycatsModulePropertiesData(
      zombieWeight: zw is num ? zw.toDouble() : 0.3,
      spawnPlantLevel: spl is int ? spl : (spl is num ? spl.toInt() : 5),
      plantBlackList: pbl is List ? pbl.map((e) => '$e').toList() : <String>[],
      zombieWhiteList: zwl is List ? zwl.map((e) => '$e').toList() : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'ZombieWeight': zombieWeight,
    'SpawnPlantLevel': spawnPlantLevel,
    'PlantBlackList': List<String>.from(plantBlackList),
    'ZombieWhiteList': List<String>.from(zombieWhiteList),
  };
}
