import 'package:c_editor/data/pvz_models/PvzModel.dart';
import 'package:c_editor/data/pvz_models/WaveGeneratorPoolEntryData.dart';
import 'package:c_editor/data/pvz_models/WaveGeneratorWaveData.dart';

class WaveGeneratorPropertiesData extends PvzModel {
  WaveGeneratorPropertiesData({
    this.addToZombiePool = const [],
    this.flagWaveInterval = 10,
    this.waveCount = 1,
    this.waveSpendingPoints = 100,
    this.waveSpendingPointIncrement = 100,
    this.waves = const [],
  });

  List<WaveGeneratorPoolEntryData> addToZombiePool;
  int flagWaveInterval;
  int waveCount;
  int waveSpendingPoints;
  int waveSpendingPointIncrement;
  List<WaveGeneratorWaveData> waves;

  bool get spendingPointsValid =>
      waveSpendingPoints <= waveSpendingPointIncrement;

  factory WaveGeneratorPropertiesData.fromJson(Map<String, dynamic> json) {
    final waves =
        (json['Waves'] as List<dynamic>?)
            ?.map(
              (e) => WaveGeneratorWaveData.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList() ??
        [];
    return WaveGeneratorPropertiesData(
      addToZombiePool:
          (json['AddToZombiePool'] as List<dynamic>?)
              ?.map(
                (e) => WaveGeneratorPoolEntryData.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          [],
      flagWaveInterval: json['FlagWaveInterval'] as int? ?? 10,
      waveCount: json['WaveCount'] as int? ?? waves.length,
      waveSpendingPoints: json['WaveSpendingPoints'] as int? ?? 100,
      waveSpendingPointIncrement:
          json['WaveSpendingPointIncrement'] as int? ?? 100,
      waves: waves,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (addToZombiePool.isNotEmpty)
        'AddToZombiePool': addToZombiePool.map((e) => e.toJson()).toList(),
      'FlagWaveInterval': flagWaveInterval,
      'WaveCount': waves.length,
      'WaveSpendingPoints': waveSpendingPoints,
      'WaveSpendingPointIncrement': waveSpendingPointIncrement,
      'Waves': waves.map((w) => w.toJson()).toList(),
    };
  }

  void syncWaveCount() {
    waveCount = waves.length;
  }
}
