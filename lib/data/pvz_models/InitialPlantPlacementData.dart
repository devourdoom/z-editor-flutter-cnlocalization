import 'package:c_editor/data/pvz_models/PvzModel.dart';

class InitialPlantPlacementData extends PvzModel {
  InitialPlantPlacementData({
    this.gridX = 0,
    this.gridY = 0,
    this.typeName = '',
    this.level = 1,
    this.condition,
  });

  int gridX;
  int gridY;
  String typeName;
  int level;
  String? condition;

  factory InitialPlantPlacementData.fromJson(Map<String, dynamic> json) {
    return InitialPlantPlacementData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      typeName: json['TypeName'] as String? ?? '',
      level: json['Level'] as int? ?? 1,
      condition: json['Condition'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'TypeName': typeName,
    'Level': level,
    if (condition != null) 'Condition': condition,
  };
}
