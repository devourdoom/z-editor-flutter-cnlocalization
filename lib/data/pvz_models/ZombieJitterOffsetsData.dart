import 'package:c_editor/data/pvz_models/PvzModel.dart';

/// Data stored by an independent `ZombieJitterOffsets` level object.
///
/// The object is not a LevelDefinition module. Basic Spawner and Underwater
/// Spawner events opt in by referencing it through their `JitterOffsets` field.
class ZombieJitterOffsetsData extends PvzModel {
  ZombieJitterOffsetsData({this.offsetIncrement = 80, this.randomJitter = 10});

  int offsetIncrement;
  int randomJitter;

  factory ZombieJitterOffsetsData.fromJson(Map<String, dynamic> json) {
    return ZombieJitterOffsetsData(
      offsetIncrement:
          (json['ZombieSpawningOffsetIncrement'] as num?)?.toInt() ?? 80,
      randomJitter: (json['ZombieSpawningRandomJitter'] as num?)?.toInt() ?? 10,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'ZombieSpawningOffsetIncrement': offsetIncrement,
    'ZombieSpawningRandomJitter': randomJitter,
  };
}
