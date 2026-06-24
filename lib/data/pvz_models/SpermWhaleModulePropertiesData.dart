import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SpermWhaleModulePropertiesData extends PvzModel {
  SpermWhaleModulePropertiesData({
    this.swallowInterval = 1,
    this.poisonSwallowInterval = 3,
    this.swallowDuration = 20,
    this.poisonTriggerCount = 2,
  });

  double swallowInterval;
  double poisonSwallowInterval;
  double swallowDuration;
  int poisonTriggerCount;

  factory SpermWhaleModulePropertiesData.fromJson(Map<String, dynamic> json) {
    return SpermWhaleModulePropertiesData(
      swallowInterval: (json['SwallowInterval'] as num?)?.toDouble() ?? 1,
      poisonSwallowInterval:
          (json['PoisonSwallowInterval'] as num?)?.toDouble() ?? 3,
      swallowDuration: (json['SwallowDuration'] as num?)?.toDouble() ?? 20,
      poisonTriggerCount: (json['PoisonTriggerCount'] as num?)?.toInt() ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {
    'SwallowInterval': swallowInterval,
    'PoisonSwallowInterval': poisonSwallowInterval,
    'SwallowDuration': swallowDuration,
    'PoisonTriggerCount': poisonTriggerCount,
  };
}
