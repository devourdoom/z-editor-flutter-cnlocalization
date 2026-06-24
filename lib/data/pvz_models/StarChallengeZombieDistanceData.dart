import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeZombieDistanceData extends PvzModel {
  StarChallengeZombieDistanceData({this.targetDistance = 5.0});
  double targetDistance;
  factory StarChallengeZombieDistanceData.fromJson(Map<String, dynamic> json) {
    return StarChallengeZombieDistanceData(
      targetDistance: (json['TargetDistance'] as num?)?.toDouble() ?? 5.0,
    );
  }
  Map<String, dynamic> toJson() => {'TargetDistance': targetDistance};
}
