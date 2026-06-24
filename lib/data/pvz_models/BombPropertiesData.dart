import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BombPropertiesData extends PvzModel {
  BombPropertiesData({
    this.flameSpeed = 0.25,
    this.fuseLengths = const ['8', '8', '8', '8', '8'],
  });

  double flameSpeed;
  List<String> fuseLengths;

  factory BombPropertiesData.fromJson(Map<String, dynamic> json) {
    final raw = json['FuseLengths'] as List<dynamic>? ?? [];
    return BombPropertiesData(
      flameSpeed: (json['FlameSpeed'] as num?)?.toDouble() ?? 0.25,
      fuseLengths: raw.map((e) => e?.toString() ?? '8').toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'FlameSpeed': flameSpeed,
    'FuseLengths': fuseLengths,
  };
}
