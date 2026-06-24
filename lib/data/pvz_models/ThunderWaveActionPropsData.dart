import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ThunderEntryData.dart';

class ThunderWaveActionPropsData extends PvzModel {
  ThunderWaveActionPropsData({this.thunders = const [], this.killRate = 0.3});

  List<ThunderEntryData> thunders;
  double killRate;

  factory ThunderWaveActionPropsData.fromJson(Map<String, dynamic> json) {
    final raw = json['Thunders'] as List<dynamic>? ?? [];
    return ThunderWaveActionPropsData(
      thunders: raw
          .map((e) => ThunderEntryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      killRate: (json['KillRate'] as num?)?.toDouble() ?? 0.3,
    );
  }

  Map<String, dynamic> toJson() => {
    'Thunders': thunders.map((e) => e.toJson()).toList(),
    'KillRate': killRate,
  };
}
