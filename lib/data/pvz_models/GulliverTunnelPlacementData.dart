import 'package:c_editor/data/pvz_models/PvzModel.dart';

class GulliverTunnelPlacementData extends PvzModel {
  GulliverTunnelPlacementData({
    this.gridX = 0,
    this.gridY = 0,
    this.orientation = 'GULLIVERTUNNEL_ORIENTATION_BIG_ON_LEFT',
  });

  int gridX;
  int gridY;
  String orientation;

  factory GulliverTunnelPlacementData.fromJson(Map<String, dynamic> json) {
    return GulliverTunnelPlacementData(
      gridX: (json['GridX'] as num?)?.toInt() ?? 0,
      gridY: (json['GridY'] as num?)?.toInt() ?? 0,
      orientation:
          json['Orientation'] as String? ??
          'GULLIVERTUNNEL_ORIENTATION_BIG_ON_LEFT',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'Orientation': orientation,
  };
}
