import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ZombossFinalStageTimeLimitedChallengePropertiesData extends PvzModel {
  ZombossFinalStageTimeLimitedChallengePropertiesData({
    this.zombossTimeLimit = 20.0,
  });

  double zombossTimeLimit;

  factory ZombossFinalStageTimeLimitedChallengePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ZombossFinalStageTimeLimitedChallengePropertiesData(
      zombossTimeLimit: (json['ZombossTimeLimit'] as num?)?.toDouble() ?? 20.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {'ZombossTimeLimit': zombossTimeLimit};
}
