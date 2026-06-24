import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeZombieSpeedData extends PvzModel {
  StarChallengeZombieSpeedData({this.speedModifier = 0.0});
  double speedModifier;
  factory StarChallengeZombieSpeedData.fromJson(Map<String, dynamic> json) {
    return StarChallengeZombieSpeedData(
      speedModifier: (json['SpeedModifier'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() => {'SpeedModifier': speedModifier};
}
