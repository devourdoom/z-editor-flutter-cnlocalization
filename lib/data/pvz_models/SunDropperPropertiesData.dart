import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SunDropperPropertiesData extends PvzModel {
  SunDropperPropertiesData({
    this.initialSunDropDelay = 2.0,
    this.sunCountdownBase = 4.25,
    this.sunCountdownMax = 9.5,
    this.sunCountdownIncreasePerSun = 0.1,
    this.sunCountdownRange = 2.75,
  });

  double initialSunDropDelay;
  double sunCountdownBase;
  double sunCountdownMax;
  double sunCountdownIncreasePerSun;
  double sunCountdownRange;

  factory SunDropperPropertiesData.fromJson(Map<String, dynamic> json) {
    return SunDropperPropertiesData(
      initialSunDropDelay:
          (json['InitialSunDropDelay'] as num?)?.toDouble() ?? 2.0,
      sunCountdownBase: (json['SunCountdownBase'] as num?)?.toDouble() ?? 4.25,
      sunCountdownMax: (json['SunCountdownMax'] as num?)?.toDouble() ?? 9.5,
      sunCountdownIncreasePerSun:
          (json['SunCountdownIncreasePerSun'] as num?)?.toDouble() ?? 0.1,
      sunCountdownRange:
          (json['SunCountdownRange'] as num?)?.toDouble() ?? 2.75,
    );
  }

  Map<String, dynamic> toJson() => {
    'InitialSunDropDelay': initialSunDropDelay,
    'SunCountdownBase': sunCountdownBase,
    'SunCountdownMax': sunCountdownMax,
    'SunCountdownIncreasePerSun': sunCountdownIncreasePerSun,
    'SunCountdownRange': sunCountdownRange,
  };
}
