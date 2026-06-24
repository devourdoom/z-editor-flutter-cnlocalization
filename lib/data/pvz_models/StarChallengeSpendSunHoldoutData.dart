import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeSpendSunHoldoutData extends PvzModel {
  StarChallengeSpendSunHoldoutData({this.holdoutSeconds = 0});
  int holdoutSeconds;
  factory StarChallengeSpendSunHoldoutData.fromJson(Map<String, dynamic> json) {
    return StarChallengeSpendSunHoldoutData(
      holdoutSeconds: json['HoldoutSeconds'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {'HoldoutSeconds': holdoutSeconds};
}
