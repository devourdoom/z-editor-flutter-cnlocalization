import 'package:c_editor/data/pvz_models/PvzModel.dart';

class TunnelRoadData extends PvzModel {
  TunnelRoadData({this.gridX = 0, this.gridY = 0, this.img = ''});

  int gridX;
  int gridY;
  String img;

  factory TunnelRoadData.fromJson(Map<String, dynamic> json) {
    return TunnelRoadData(
      gridX: json['GridX'] as int? ?? 0,
      gridY: json['GridY'] as int? ?? 0,
      img: json['Img'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'GridX': gridX, 'GridY': gridY, 'Img': img};
}
