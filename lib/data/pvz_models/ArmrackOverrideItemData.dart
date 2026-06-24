import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ArmrackOverrideItemData extends PvzModel {
  ArmrackOverrideItemData({
    this.mX = 0,
    this.mY = 0,
    this.type = 'ArmrackFlag',
  });

  int mX;
  int mY;
  String type;

  factory ArmrackOverrideItemData.fromJson(Map<String, dynamic> json) {
    return ArmrackOverrideItemData(
      mX: (json['mX'] as num?)?.toInt() ?? 0,
      mY: (json['mY'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'ArmrackFlag',
    );
  }

  Map<String, dynamic> toJson() => {'mX': mX, 'mY': mY, 'type': type};
}
