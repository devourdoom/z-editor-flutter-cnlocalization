import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/wave_generator_point_analysis.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WaveGeneratorPointAnalysis.poolAtWave', () {
    test('includes global and current wave AddToZombiePool', () {
      final data = WaveGeneratorPropertiesData(
        addToZombiePool: [
          WaveGeneratorPoolEntryData(type: 'RTID(kongfu_basic@ZombieTypes)'),
        ],
        waves: [
          WaveGeneratorWaveData(),
          WaveGeneratorWaveData(
            addToZombiePool: [
              WaveGeneratorPoolEntryData(type: 'RTID(kongfu_flag@ZombieTypes)'),
            ],
          ),
        ],
      );

      final pool = WaveGeneratorPointAnalysis.poolAtWave(data, 2);

      expect(pool, [
        'RTID(kongfu_basic@ZombieTypes)',
        'RTID(kongfu_flag@ZombieTypes)',
      ]);
    });

    test('includes only current wave pool when global is empty', () {
      final data = WaveGeneratorPropertiesData(
        waves: [
          WaveGeneratorWaveData(),
          WaveGeneratorWaveData(
            addToZombiePool: [
              WaveGeneratorPoolEntryData(type: 'RTID(kongfu_flag@ZombieTypes)'),
            ],
          ),
        ],
      );

      final pool = WaveGeneratorPointAnalysis.poolAtWave(data, 2);

      expect(pool, ['RTID(kongfu_flag@ZombieTypes)']);
    });

    test('keeps duplicate pool slots for weight aggregation', () {
      final data = WaveGeneratorPropertiesData(
        addToZombiePool: [
          WaveGeneratorPoolEntryData(type: 'RTID(kongfu_basic@ZombieTypes)'),
          WaveGeneratorPoolEntryData(type: 'RTID(kongfu_basic@ZombieTypes)'),
        ],
        waves: [
          WaveGeneratorWaveData(
            disableRandomSpawns: false,
            addToZombiePool: [
              WaveGeneratorPoolEntryData(
                type: 'RTID(kongfu_basic@ZombieTypes)',
              ),
            ],
          ),
        ],
      );

      final pool = WaveGeneratorPointAnalysis.poolAtWave(data, 1);
      expect(pool.length, 3);
    });
  });
}
