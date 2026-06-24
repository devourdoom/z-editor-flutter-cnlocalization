import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/RiftTimedSunData.dart';

class RiftTimedSunModuleData extends PvzModel {
  RiftTimedSunModuleData({this.sunDrops = const []});

  List<RiftTimedSunData> sunDrops;

  factory RiftTimedSunModuleData.fromJson(Map<String, dynamic> json) {
    final raw = json['SunDrops'] as List<dynamic>? ?? [];
    return RiftTimedSunModuleData(
      sunDrops: raw
          .map((e) => RiftTimedSunData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'SunDrops': sunDrops.map((e) => e.toJson()).toList(),
  };
}
