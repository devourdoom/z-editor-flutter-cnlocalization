import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeSunProducedData extends PvzModel {
  StarChallengeSunProducedData({this.targetSun = 0});
  int targetSun;
  factory StarChallengeSunProducedData.fromJson(Map<String, dynamic> json) {
    return StarChallengeSunProducedData(
      targetSun: json['TargetSun'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {'TargetSun': targetSun};
}
