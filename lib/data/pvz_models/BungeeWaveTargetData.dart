import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BungeeWaveTargetData extends PvzModel {
  BungeeWaveTargetData({this.mX = 0, this.mY = 0});

  int mX;
  int mY;

  factory BungeeWaveTargetData.fromJson(Map<String, dynamic> json) {
    return BungeeWaveTargetData(
      mX: json['mX'] as int? ?? 0,
      mY: json['mY'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'mX': mX, 'mY': mY};
}
