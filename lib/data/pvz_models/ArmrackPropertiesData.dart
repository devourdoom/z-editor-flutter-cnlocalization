import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ArmrackOverrideWaveData.dart';

class ArmrackPropertiesData extends PvzModel {
  ArmrackPropertiesData({List<ArmrackOverrideWaveData>? overrides})
    : overrides = overrides ?? [];

  List<ArmrackOverrideWaveData> overrides;

  factory ArmrackPropertiesData.fromJson(Map<String, dynamic> json) {
    final list = json['Overrides'] as List<dynamic>?;
    return ArmrackPropertiesData(
      overrides:
          list
              ?.map(
                (e) =>
                    ArmrackOverrideWaveData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Overrides': overrides.map((e) => e.toJson()).toList(),
  };
}
