import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeSunUsedData extends PvzModel {
  StarChallengeSunUsedData({this.maximumSun = 2000});
  int maximumSun;
  factory StarChallengeSunUsedData.fromJson(Map<String, dynamic> json) {
    return StarChallengeSunUsedData(
      maximumSun: json['MaximumSun'] as int? ?? 2000,
    );
  }
  Map<String, dynamic> toJson() => {'MaximumSun': maximumSun};
}
