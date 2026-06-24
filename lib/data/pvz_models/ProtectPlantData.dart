import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ProtectPlantData extends PvzModel {
  ProtectPlantData({this.gridX = 0, this.gridY = 0, this.plantType = ''});

  int gridX;
  int gridY;
  String plantType;

  factory ProtectPlantData.fromJson(Map<String, dynamic> json) {
    return ProtectPlantData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      plantType: json['PlantType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'PlantType': plantType,
  };
}
