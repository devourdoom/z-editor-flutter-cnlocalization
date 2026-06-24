import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/repository/zombie_properties_repository.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/data/wave_point_analysis.dart';

/// Point budget and random-spawn expectation for [WaveGeneratorProperties].
class WaveGeneratorPointAnalysis {
  WaveGeneratorPointAnalysis._();

  static int pointsAtWave(
    WaveGeneratorPropertiesData data,
    int waveIndex, {
    required bool isFlagWave,
  }) {
    if (waveIndex < 1) return 0;
    final wave = waveIndex <= data.waves.length
        ? data.waves[waveIndex - 1]
        : null;

    var basePoints =
        wave?.wavePointStart ??
        data.waveSpendingPoints +
            (waveIndex - 1) * data.waveSpendingPointIncrement;
    if (basePoints > 60000) basePoints = 60000;
    return isFlagWave ? (basePoints * 2.5).toInt() : basePoints;
  }

  /// Cumulative zombie pool eligible on [waveIndex] (1-based), including global
  /// [AddToZombiePool] and per-wave additions through the current wave.
  static List<String> poolAtWave(
    WaveGeneratorPropertiesData data,
    int waveIndex,
  ) {
    if (waveIndex < 1) return [];
    final pool = <String>[];
    for (final entry in data.addToZombiePool) {
      pool.add(entry.type);
    }
    final wavesToInclude = waveIndex.clamp(0, data.waves.length);
    for (var waveNumber = 1; waveNumber <= wavesToInclude; waveNumber++) {
      for (final entry in data.waves[waveNumber - 1].addToZombiePool) {
        pool.add(entry.type);
      }
    }
    return pool;
  }

  static List<InputEntry> _poolInputEntries(List<String> pool) {
    final weightByType = <String, double>{};
    final costByType = <String, int>{};
    for (final rtid in pool) {
      final alias = RtidParser.parse(rtid)?.alias ?? rtid;
      final typeName = ZombiePropertiesRepository.getTypeNameByAlias(alias);
      final stats = ZombiePropertiesRepository.getStats(typeName);
      weightByType[typeName] =
          (weightByType[typeName] ?? 0) + stats.weight.toDouble();
      costByType[typeName] = stats.cost;
    }
    return weightByType.entries
        .map(
          (entry) => InputEntry(
            id: entry.key,
            cost: costByType[entry.key]!,
            weight: entry.value,
          ),
        )
        .toList();
  }

  static Map<String, double> calculateExpectation(
    WaveGeneratorPropertiesData data,
    int waveIndex, {
    required bool isFlagWave,
  }) {
    final points = pointsAtWave(data, waveIndex, isFlagWave: isFlagWave);
    if (points <= 0) return {};
    final pool = poolAtWave(data, waveIndex);
    if (pool.isEmpty) return {};

    final inputs = _poolInputEntries(pool);

    return WavePointAnalysis.calculate(inputs, points);
  }

  static bool showExpectationForWave(
    WaveGeneratorPropertiesData data,
    int waveIndex,
  ) {
    if (waveIndex < 1 || waveIndex > data.waves.length) return false;
    if (data.waves[waveIndex - 1].disableRandomSpawns) return false;
    final interval = data.flagWaveInterval <= 0 ? 10 : data.flagWaveInterval;
    final isFlag = waveIndex % interval == 0 || waveIndex == data.waves.length;
    final points = pointsAtWave(data, waveIndex, isFlagWave: isFlag);
    return points > 0 && poolAtWave(data, waveIndex).isNotEmpty;
  }
}
