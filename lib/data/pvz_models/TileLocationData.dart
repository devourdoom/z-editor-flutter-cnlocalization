import 'package:c_editor/data/pvz_models/PvzModel.dart';

class TileLocationData extends PvzModel {
  TileLocationData({this.mx = 0, this.my = 0});

  int mx;
  int my;

  factory TileLocationData.fromJson(Map<String, dynamic> json) {
    return TileLocationData(
      mx: json['mX'] as int? ?? 0,
      my: json['mY'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'mX': mx, 'mY': my};
}
