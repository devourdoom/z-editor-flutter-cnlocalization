import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeUnfreezePlantsData extends PvzModel {
  StarChallengeUnfreezePlantsData({this.count = 0});
  int count;
  factory StarChallengeUnfreezePlantsData.fromJson(Map<String, dynamic> json) {
    return StarChallengeUnfreezePlantsData(count: json['Count'] as int? ?? 0);
  }
  Map<String, dynamic> toJson() => {'Count': count};
}
