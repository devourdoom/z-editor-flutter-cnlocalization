import 'package:c_editor/data/pvz_models/PvzModel.dart';

class FairyTaleWindWaveActionData extends PvzModel {
  FairyTaleWindWaveActionData({this.duration = 5.0, this.velocityScale = 2.0});

  double duration;
  double velocityScale;

  factory FairyTaleWindWaveActionData.fromJson(Map<String, dynamic> json) {
    return FairyTaleWindWaveActionData(
      duration: (json['Duration'] as num?)?.toDouble() ?? 5.0,
      velocityScale: (json['VelocityScale'] as num?)?.toDouble() ?? 2.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'Duration': duration,
    'VelocityScale': velocityScale,
  };
}
