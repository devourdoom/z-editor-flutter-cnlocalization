import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RectData extends PvzModel {
  RectData({this.mX = 0, this.mY = 0, this.mWidth = 0, this.mHeight = 0});

  int mX;
  int mY;
  int mWidth;
  int mHeight;

  factory RectData.fromJson(Map<String, dynamic> json) {
    return RectData(
      mX: json['mX'] as int? ?? 0,
      mY: json['mY'] as int? ?? 0,
      mWidth: json['mWidth'] as int? ?? 0,
      mHeight: json['mHeight'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'mX': mX,
    'mY': mY,
    'mWidth': mWidth,
    'mHeight': mHeight,
  };
}
