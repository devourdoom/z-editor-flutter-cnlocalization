import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/LocationData.dart';
import 'package:c_editor/data/pvz_models/VaseDefinition.dart';

class VaseBreakerPresetData extends PvzModel {
  VaseBreakerPresetData({
    this.minColumnIndex = 4,
    this.maxColumnIndex = 8,
    this.numColoredPlantVases = 0,
    this.numColoredZombieVases = 0,
    this.gridSquareBlacklist = const [],
    this.vases = const [],
  });

  int minColumnIndex;
  int maxColumnIndex;
  int numColoredPlantVases;
  int numColoredZombieVases;
  List<LocationData> gridSquareBlacklist;
  List<VaseDefinition> vases;

  factory VaseBreakerPresetData.fromJson(Map<String, dynamic> json) {
    return VaseBreakerPresetData(
      minColumnIndex: json['MinColumnIndex'] as int? ?? 4,
      maxColumnIndex: json['MaxColumnIndex'] as int? ?? 8,
      numColoredPlantVases: json['NumColoredPlantVases'] as int? ?? 0,
      numColoredZombieVases: json['NumColoredZombieVases'] as int? ?? 0,
      gridSquareBlacklist:
          (json['GridSquareBlacklist'] as List<dynamic>?)
              ?.map((e) => LocationData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vases:
          (json['Vases'] as List<dynamic>?)
              ?.map((e) => VaseDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'MinColumnIndex': minColumnIndex,
    'MaxColumnIndex': maxColumnIndex,
    'NumColoredPlantVases': numColoredPlantVases,
    'NumColoredZombieVases': numColoredZombieVases,
    'GridSquareBlacklist': gridSquareBlacklist.map((e) => e.toJson()).toList(),
    'Vases': vases.map((e) => e.toJson()).toList(),
  };
}
