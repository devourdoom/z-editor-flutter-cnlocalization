import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/DropShipAppearWaveData.dart';

class DropShipPropertiesData extends PvzModel {
  DropShipPropertiesData({List<DropShipAppearWaveData>? appearWaves})
    : appearWaves = appearWaves ?? [];

  List<DropShipAppearWaveData> appearWaves;

  factory DropShipPropertiesData.fromJson(Map<String, dynamic> json) {
    final list = json['AppearWaves'] as List<dynamic>?;
    return DropShipPropertiesData(
      appearWaves:
          list
              ?.map(
                (e) =>
                    DropShipAppearWaveData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'AppearWaves': appearWaves.map((e) => e.toJson()).toList(),
  };
}
