import 'package:c_editor/data/pvz_models/PvzModel.dart';

class TideWaveWaveActionPropsData extends PvzModel {
  TideWaveWaveActionPropsData({
    this.type = 'left',
    this.duration = 10,
    this.submarineMovingDistance = 1,
    this.speedUpDuration = 3,
    this.speedUpIncreased = 2,
    this.submarineMovingTime = 1.5,
    this.zombieMovingSpeed = 180,
  });

  /// left | right
  String type;
  double duration;
  double submarineMovingDistance;
  double speedUpDuration;
  double speedUpIncreased;
  double submarineMovingTime;
  double zombieMovingSpeed;

  factory TideWaveWaveActionPropsData.fromJson(Map<String, dynamic> json) {
    return TideWaveWaveActionPropsData(
      type: json['Type'] as String? ?? 'left',
      duration: (json['Duration'] as num?)?.toDouble() ?? 10,
      submarineMovingDistance:
          (json['SubmarineMovingDistance'] as num?)?.toDouble() ?? 1,
      speedUpDuration: (json['SpeedUpDuration'] as num?)?.toDouble() ?? 3,
      speedUpIncreased: (json['SpeedUpIncreased'] as num?)?.toDouble() ?? 2,
      submarineMovingTime:
          (json['SubmarineMovingTime'] as num?)?.toDouble() ?? 1.5,
      zombieMovingSpeed: (json['ZombieMovingSpeed'] as num?)?.toDouble() ?? 180,
    );
  }

  Map<String, dynamic> toJson() => {
    'Type': type,
    'Duration': duration,
    'SubmarineMovingDistance': submarineMovingDistance,
    'SpeedUpDuration': speedUpDuration,
    'SpeedUpIncreased': speedUpIncreased,
    'SubmarineMovingTime': submarineMovingTime,
    'ZombieMovingSpeed': zombieMovingSpeed,
  };
}
