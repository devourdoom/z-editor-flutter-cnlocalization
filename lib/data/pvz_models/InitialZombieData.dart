import 'package:c_editor/data/pvz_models/PvzModel.dart';

class InitialZombieData extends PvzModel {
  InitialZombieData({
    this.gridX = 0,
    this.gridY = 0,
    this.typeName = '',
    this.condition = 'icecubed',
  });

  int gridX;
  int gridY;
  String typeName;
  String condition;

  factory InitialZombieData.fromJson(Map<String, dynamic> json) {
    return InitialZombieData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      typeName: json['TypeName'] as String? ?? '',
      condition: json['Condition'] as String? ?? 'icecubed',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'TypeName': typeName,
    'Condition': condition,
  };
}
