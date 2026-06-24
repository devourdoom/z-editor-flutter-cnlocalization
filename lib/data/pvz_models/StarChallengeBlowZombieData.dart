import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeBlowZombieData extends PvzModel {
  StarChallengeBlowZombieData({this.count = 0});
  int count;
  factory StarChallengeBlowZombieData.fromJson(Map<String, dynamic> json) {
    return StarChallengeBlowZombieData(count: json['Count'] as int? ?? 0);
  }
  Map<String, dynamic> toJson() => {'Count': count};
}
