import 'package:c_editor/data/pvz_models/PvzModel.dart';

class WaveManagerData extends PvzModel {
  WaveManagerData({
    this.waveCount = 1,
    this.flagWaveInterval = 10,
    this.suppressFlagZombie,
    this.levelJam,
    this.zombieCountDownFirstWaveSecs = 12,
    this.zombieCountDownFirstWaveConveyorSecs = 5,
    this.zombieCountDownHugeWaveDelay = 5,
    this.maxNextWaveHealthPercentage = 0.85,
    this.minNextWaveHealthPercentage = 0.70,
    this.waves = const [],
  });

  int waveCount;
  int flagWaveInterval;
  bool? suppressFlagZombie;
  String? levelJam;
  int? zombieCountDownFirstWaveSecs;
  int? zombieCountDownFirstWaveConveyorSecs;
  int? zombieCountDownHugeWaveDelay;
  double maxNextWaveHealthPercentage;
  double minNextWaveHealthPercentage;
  List<List<String>> waves;

  factory WaveManagerData.fromJson(Map<String, dynamic> json) {
    var wavesList = <List<String>>[];
    if (json['Waves'] != null) {
      wavesList = (json['Waves'] as List<dynamic>)
          .map(
            (wave) => (wave as List<dynamic>).map((e) => e as String).toList(),
          )
          .toList();
    }

    return WaveManagerData(
      waveCount: json['WaveCount'] as int? ?? 1,
      flagWaveInterval: json['FlagWaveInterval'] as int? ?? 10,
      suppressFlagZombie: json['SuppressFlagZombie'] as bool?,
      levelJam: json['LevelJam'] as String?,
      zombieCountDownFirstWaveSecs:
          json['ZombieCountDownFirstWaveSecs'] as int?,
      zombieCountDownFirstWaveConveyorSecs:
          json['ZombieCountDownFirstWaveConveyorSecs'] as int?,
      zombieCountDownHugeWaveDelay:
          json['ZombieCountDownHugeWaveDelay'] as int?,
      maxNextWaveHealthPercentage:
          (json['MaxNextWaveHealthPercentage'] as num?)?.toDouble() ?? 0.85,
      minNextWaveHealthPercentage:
          (json['MinNextWaveHealthPercentage'] as num?)?.toDouble() ?? 0.70,
      waves: wavesList,
    );
  }

  Map<String, dynamic> toJson() => {
    'WaveCount': waveCount,
    'FlagWaveInterval': flagWaveInterval,
    if (suppressFlagZombie != null) 'SuppressFlagZombie': suppressFlagZombie,
    if (levelJam != null) 'LevelJam': levelJam,
    if (zombieCountDownFirstWaveSecs != null)
      'ZombieCountDownFirstWaveSecs': zombieCountDownFirstWaveSecs,
    if (zombieCountDownFirstWaveConveyorSecs != null)
      'ZombieCountDownFirstWaveConveyorSecs':
          zombieCountDownFirstWaveConveyorSecs,
    if (zombieCountDownHugeWaveDelay != null)
      'ZombieCountDownHugeWaveDelay': zombieCountDownHugeWaveDelay,
    'MaxNextWaveHealthPercentage': maxNextWaveHealthPercentage,
    'MinNextWaveHealthPercentage': minNextWaveHealthPercentage,
    'Waves': waves,
  };
}
