import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/BarrelZombieData.dart';

class BarrelParamsData extends PvzModel {
  BarrelParamsData({
    this.barrelHitPoints = 1100,
    this.barrelSpeed = 0.1,
    this.barrelBlowDamageAmount,
    this.zombies = const [],
  });

  int barrelHitPoints;
  double barrelSpeed;

  /// Explosion damage for explosive barrels (barrelpowder). Null = omit from JSON.
  int? barrelBlowDamageAmount;
  List<BarrelZombieData> zombies;

  factory BarrelParamsData.fromJson(Map<String, dynamic> json) {
    final raw = json['Zombies'] as List<dynamic>? ?? [];
    return BarrelParamsData(
      barrelHitPoints: json['BarrelHitPoints'] as int? ?? 1100,
      barrelSpeed: (json['BarrelSpeed'] as num?)?.toDouble() ?? 0.1,
      barrelBlowDamageAmount: json['BarrelBlowDamageAmount'] as int?,
      zombies: raw
          .map((e) => BarrelZombieData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'BarrelHitPoints': barrelHitPoints,
      'BarrelSpeed': barrelSpeed,
    };
    if (barrelBlowDamageAmount != null) {
      m['BarrelBlowDamageAmount'] = barrelBlowDamageAmount!;
    }
    if (zombies.isNotEmpty) {
      m['Zombies'] = zombies.map((e) => e.toJson()).toList();
    }
    return m;
  }
}
