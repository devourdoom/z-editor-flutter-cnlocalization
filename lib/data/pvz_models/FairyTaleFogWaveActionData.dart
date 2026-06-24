import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/FogRangeData.dart';

class FairyTaleFogWaveActionData extends PvzModel {
  FairyTaleFogWaveActionData({
    this.movingTime = 3.0,
    this.fogType = 'fairy_tale_fog_lvl1',
    FogRangeData? range,
  }) : range = range ?? FogRangeData();

  double movingTime;
  String fogType;
  FogRangeData range;

  factory FairyTaleFogWaveActionData.fromJson(Map<String, dynamic> json) {
    return FairyTaleFogWaveActionData(
      movingTime: (json['MovingTime'] as num?)?.toDouble() ?? 3.0,
      fogType: json['FogType'] as String? ?? 'fairy_tale_fog_lvl1',
      range: FogRangeData.fromJson(
        json['Range'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'MovingTime': movingTime,
    'FogType': fogType,
    'Range': range.toJson(),
  };
}
