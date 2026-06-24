import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/SeedRainItem.dart';

class SeedRainPropertiesData extends PvzModel {
  SeedRainPropertiesData({this.rainInterval = 5, this.seedRains = const []});

  int rainInterval;
  List<SeedRainItem> seedRains;

  factory SeedRainPropertiesData.fromJson(Map<String, dynamic> json) {
    return SeedRainPropertiesData(
      rainInterval: json['RainInterval'] as int? ?? 5,
      seedRains:
          (json['SeedRains'] as List<dynamic>?)
              ?.map((e) => SeedRainItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'RainInterval': rainInterval,
    'SeedRains': seedRains.map((e) => e.toJson()).toList(),
  };
}
