import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/BungeeWaveTargetData.dart';

class BungeeWaveActionData extends PvzModel {
  BungeeWaveActionData({
    BungeeWaveTargetData? target,
    this.zombieName = 'tutorial',
    this.level = 1,
  }) : target = target ?? BungeeWaveTargetData();

  BungeeWaveTargetData target;
  String zombieName;
  int level;

  factory BungeeWaveActionData.fromJson(Map<String, dynamic> json) {
    final t = json['Target'];
    return BungeeWaveActionData(
      target: t is Map<String, dynamic>
          ? BungeeWaveTargetData.fromJson(t)
          : BungeeWaveTargetData(),
      zombieName: json['ZombieName'] as String? ?? '',
      level: json['Level'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'Target': target.toJson(),
    'ZombieName': zombieName,
    'Level': level,
  };
}
