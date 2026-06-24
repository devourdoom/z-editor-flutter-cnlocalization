import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SeedRainItem extends PvzModel {
  SeedRainItem({
    this.seedRainType = 0,
    this.plantTypeName,
    this.zombieTypeName,
    this.maxCount = 5,
    this.weight = 100,
  });

  int seedRainType;
  String? plantTypeName;
  String? zombieTypeName;
  int maxCount;
  int weight;

  factory SeedRainItem.fromJson(Map<String, dynamic> json) {
    return SeedRainItem(
      seedRainType: json['SeedRainType'] as int? ?? 0,
      plantTypeName: json['PlantTypeName'] as String?,
      zombieTypeName: json['ZombieTypeName'] as String?,
      maxCount: json['MaxCount'] as int? ?? 5,
      weight: json['Weight'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() => {
    'SeedRainType': seedRainType,
    'PlantTypeName': plantTypeName,
    'ZombieTypeName': zombieTypeName,
    'MaxCount': maxCount,
    'Weight': weight,
  };
}
