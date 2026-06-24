import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/TunnelRoadData.dart';

class TunnelDefendModuleData extends PvzModel {
  TunnelDefendModuleData({
    List<TunnelRoadData>? roads,
    this.brickMapIndex = 1,
    this.tunnelSequenceInterval = 0.4,
  }) : roads = roads ?? [];

  List<TunnelRoadData> roads;

  /// Tile style preset in game (`BrickMapIndex`): 1 or 2 only.
  int brickMapIndex;

  double tunnelSequenceInterval;

  factory TunnelDefendModuleData.fromJson(Map<String, dynamic> json) {
    final raw = (json['BrickMapIndex'] as num?)?.toInt() ?? 1;
    return TunnelDefendModuleData(
      roads:
          (json['Roads'] as List<dynamic>?)
              ?.map((e) => TunnelRoadData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      brickMapIndex: raw == 2 ? 2 : 1,
      tunnelSequenceInterval:
          (json['TunnelSequenceInterval'] as num?)?.toDouble() ?? 0.4,
    );
  }

  Map<String, dynamic> toJson() => {
    'Roads': roads.map((e) => e.toJson()).toList(),
    'BrickMapIndex': brickMapIndex,
    'TunnelSequenceInterval': tunnelSequenceInterval,
  };
}
