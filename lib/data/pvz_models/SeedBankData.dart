import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SeedBankData extends PvzModel {
  SeedBankData({
    this.presetPlantList = const [],
    this.plantWhiteList = const [],
    this.plantBlackList = const [],
    this.selectionMethod = 'chooser',
    this.globalLevel,
    this.overrideSeedSlotsCount = 8,
    this.zombieMode,
    this.seedPacketType,
    this.gridItemMode,
  });

  List<String> presetPlantList;
  List<String> plantWhiteList;
  List<String> plantBlackList;
  String selectionMethod;
  int? globalLevel;
  int? overrideSeedSlotsCount;
  bool? zombieMode;
  String? seedPacketType;
  bool? gridItemMode;

  factory SeedBankData.fromJson(Map<String, dynamic> json) {
    return SeedBankData(
      presetPlantList:
          (json['PresetPlantList'] as List<dynamic>?)?.cast<String>() ?? [],
      plantWhiteList:
          (json['PlantWhiteList'] as List<dynamic>?)?.cast<String>() ?? [],
      plantBlackList:
          (json['PlantBlackList'] as List<dynamic>?)?.cast<String>() ?? [],
      selectionMethod: json['SelectionMethod'] as String? ?? 'chooser',
      globalLevel: json['GlobalLevel'] as int?,
      overrideSeedSlotsCount: json['OverrideSeedSlotsCount'] as int? ?? 8,
      zombieMode: json['ZombieMode'] as bool?,
      seedPacketType: json['SeedPacketType'] as String?,
      gridItemMode: json['GridItemMode'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'PresetPlantList': presetPlantList,
    'PlantWhiteList': plantWhiteList,
    'PlantBlackList': plantBlackList,
    'SelectionMethod': selectionMethod,
    if (globalLevel != null) 'GlobalLevel': globalLevel,
    if (overrideSeedSlotsCount != null)
      'OverrideSeedSlotsCount': overrideSeedSlotsCount,
    if (zombieMode != null) 'ZombieMode': zombieMode,
    if (seedPacketType != null) 'SeedPacketType': seedPacketType,
    if (gridItemMode == true) 'GridItemMode': true,
  };
}

/// Grid items offered when [SeedBankData.gridItemMode] is enabled.
const kSeedBankGridItemIds = [
  'FrozenChillyPepper',
  'FrozenIcebloom',
  'BesiegeBox',
];
