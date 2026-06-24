import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SunBombChallengeData extends PvzModel {
  SunBombChallengeData({
    this.plantBombExplosionRadius = 25,
    this.zombieBombExplosionRadius = 80,
    this.plantDamage = 1000,
    this.zombieDamage = 500,
  });

  int plantBombExplosionRadius;
  int zombieBombExplosionRadius;
  int plantDamage;
  int zombieDamage;

  factory SunBombChallengeData.fromJson(Map<String, dynamic> json) {
    return SunBombChallengeData(
      plantBombExplosionRadius: json['PlantBombExplosionRadius'] as int? ?? 25,
      zombieBombExplosionRadius:
          json['ZombieBombExplosionRadius'] as int? ?? 80,
      plantDamage: json['PlantDamage'] as int? ?? 1000,
      zombieDamage: json['ZombieDamage'] as int? ?? 500,
    );
  }

  Map<String, dynamic> toJson() => {
    'PlantBombExplosionRadius': plantBombExplosionRadius,
    'ZombieBombExplosionRadius': zombieBombExplosionRadius,
    'PlantDamage': plantDamage,
    'ZombieDamage': zombieDamage,
  };
}
