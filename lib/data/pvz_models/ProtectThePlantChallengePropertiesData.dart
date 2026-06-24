import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ProtectPlantData.dart';

class ProtectThePlantChallengePropertiesData extends PvzModel {
  ProtectThePlantChallengePropertiesData({
    this.mustProtectCount = 0,
    this.plants = const [],
  });

  int mustProtectCount;
  List<ProtectPlantData> plants;

  factory ProtectThePlantChallengePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProtectThePlantChallengePropertiesData(
      mustProtectCount: json['MustProtectCount'] as int? ?? 0,
      plants:
          (json['Plants'] as List<dynamic>?)
              ?.map((e) => ProtectPlantData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'MustProtectCount': mustProtectCount,
    'Plants': plants.map((e) => e.toJson()).toList(),
  };
}
