import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/HeianWindWaveWindInfoData.dart';

class HeianWindModulePropertiesData extends PvzModel {
  HeianWindModulePropertiesData({
    List<HeianWindWaveWindInfoData>? waveWindInfos,
  }) : waveWindInfos = waveWindInfos ?? [];

  List<HeianWindWaveWindInfoData> waveWindInfos;

  factory HeianWindModulePropertiesData.fromJson(Map<String, dynamic> json) {
    final list = json['WaveWindInfos'] as List<dynamic>?;
    return HeianWindModulePropertiesData(
      waveWindInfos:
          list
              ?.map(
                (e) => HeianWindWaveWindInfoData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'WaveWindInfos': waveWindInfos.map((e) => e.toJson()).toList(),
  };
}
