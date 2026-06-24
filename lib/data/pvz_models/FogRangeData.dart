import 'package:c_editor/data/pvz_models/PvzModel.dart';

class FogRangeData extends PvzModel {
  FogRangeData({this.mX = 4, this.mY = 0, this.mWidth = 8, this.mHeight = 5});

  int mX;
  int mY;
  int mWidth;
  int mHeight;

  factory FogRangeData.fromJson(Map<String, dynamic> json) {
    return FogRangeData(
      mX: json['mX'] as int? ?? 4,
      mY: json['mY'] as int? ?? 0,
      mWidth: json['mWidth'] as int? ?? 8,
      mHeight: json['mHeight'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
    'mX': mX,
    'mY': mY,
    'mWidth': mWidth,
    'mHeight': mHeight,
  };
}
