import 'package:c_editor/data/pvz_models/PvzModel.dart';

class InitialPlantData extends PvzModel {
  InitialPlantData({
    this.gridX = 0,
    this.gridY = 0,
    this.level = 1,
    this.avatar = false,
    this.plantTypes = const [],
  });

  int gridX;
  int gridY;
  int level;
  bool avatar;
  List<String> plantTypes;

  factory InitialPlantData.fromJson(Map<String, dynamic> json) {
    return InitialPlantData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      level: json['Level'] as int? ?? 1,
      avatar: json['Avatar'] as bool? ?? false,
      plantTypes: (json['PlantTypes'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'Level': level,
    'Avatar': avatar,
    'PlantTypes': plantTypes,
  };
}
