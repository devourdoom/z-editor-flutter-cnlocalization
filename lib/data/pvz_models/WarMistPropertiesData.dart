import 'package:c_editor/data/pvz_models/PvzModel.dart';

class WarMistPropertiesData extends PvzModel {
  WarMistPropertiesData({
    this.initMistPosX = 5,
    this.normValX = 1000,
    this.bloverEffectInterval = 15,
  });

  int initMistPosX;
  int normValX;
  int bloverEffectInterval;

  factory WarMistPropertiesData.fromJson(Map<String, dynamic> json) {
    return WarMistPropertiesData(
      initMistPosX: json['m_iInitMistPosX'] as int? ?? 5,
      normValX: json['m_iNormValX'] as int? ?? 1000,
      bloverEffectInterval: json['m_iBloverEffectInterval'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() => {
    'm_iInitMistPosX': initMistPosX,
    'm_iNormValX': normValX,
    'm_iBloverEffectInterval': bloverEffectInterval,
  };
}
