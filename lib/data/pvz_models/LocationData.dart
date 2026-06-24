import 'package:c_editor/data/pvz_models/PvzModel.dart';

class LocationData extends PvzModel {
  LocationData({this.x = 0, this.y = 0});

  int x;
  int y;

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(x: json['mX'] as int? ?? 0, y: json['mY'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() => {'mX': x, 'mY': y};
}
