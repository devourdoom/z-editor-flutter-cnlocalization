import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/BarrelEntryData.dart';

class BarrelWaveEventData extends PvzModel {
  BarrelWaveEventData({this.barrels = const []});

  List<BarrelEntryData> barrels;

  factory BarrelWaveEventData.fromJson(Map<String, dynamic> json) {
    final raw = json['Barrels'] as List<dynamic>? ?? [];
    return BarrelWaveEventData(
      barrels: raw
          .map((e) => BarrelEntryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Barrels': barrels.map((e) => e.toJson()).toList(),
  };
}
