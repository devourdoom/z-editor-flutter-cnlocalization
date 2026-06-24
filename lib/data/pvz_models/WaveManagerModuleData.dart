import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/DynamicZombieGroup.dart';

class WaveManagerModuleData extends PvzModel {
  WaveManagerModuleData({
    List<DynamicZombieGroup>? dynamicZombies,
    this.waveManagerProps,
    this.manualStartup,
  }) : dynamicZombies = dynamicZombies ?? [];

  List<DynamicZombieGroup> dynamicZombies;
  String? waveManagerProps;
  bool? manualStartup;

  factory WaveManagerModuleData.fromJson(Map<String, dynamic> json) {
    return WaveManagerModuleData(
      dynamicZombies:
          (json['DynamicZombies'] as List<dynamic>?)
              ?.map(
                (e) => DynamicZombieGroup.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <DynamicZombieGroup>[],
      waveManagerProps: json['WaveManagerProps'] as String?,
      manualStartup: json['ManualStartup'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'DynamicZombies': dynamicZombies.map((e) => e.toJson()).toList(),
    if (waveManagerProps != null) 'WaveManagerProps': waveManagerProps,
    if (manualStartup != null) 'ManualStartup': manualStartup,
  };
}
