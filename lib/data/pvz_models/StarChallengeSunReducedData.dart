import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeSunReducedData extends PvzModel {
  StarChallengeSunReducedData({this.sunModifier = 0.0});
  double sunModifier;
  factory StarChallengeSunReducedData.fromJson(Map<String, dynamic> json) {
    return StarChallengeSunReducedData(
      sunModifier: (json['sunModifier'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() => {'sunModifier': sunModifier};
}
