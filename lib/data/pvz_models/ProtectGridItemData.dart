import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ProtectGridItemData extends PvzModel {
  ProtectGridItemData({this.gridX = 0, this.gridY = 0, this.gridItemType = ''});

  int gridX;
  int gridY;
  String gridItemType;

  factory ProtectGridItemData.fromJson(Map<String, dynamic> json) {
    return ProtectGridItemData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      gridItemType: json['GridItemType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'GridItemType': gridItemType,
  };
}
