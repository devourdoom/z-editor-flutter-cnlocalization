import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengePlantsLostData extends PvzModel {
  StarChallengePlantsLostData({this.maximumPlantsLost = 10});
  int maximumPlantsLost;
  factory StarChallengePlantsLostData.fromJson(Map<String, dynamic> json) {
    return StarChallengePlantsLostData(
      maximumPlantsLost: json['MaximumPlantsLost'] as int? ?? 10,
    );
  }
  Map<String, dynamic> toJson() => {'MaximumPlantsLost': maximumPlantsLost};
}
