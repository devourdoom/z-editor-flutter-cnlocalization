import 'package:c_editor/data/pvz_models/PvzModel.dart';

class InitialGridItemData extends PvzModel {
  InitialGridItemData({this.gridX = 0, this.gridY = 0, this.typeName = ''});

  int gridX;
  int gridY;
  String typeName;

  factory InitialGridItemData.fromJson(Map<String, dynamic> json) {
    return InitialGridItemData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      typeName: json['TypeName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'TypeName': typeName,
  };
}
