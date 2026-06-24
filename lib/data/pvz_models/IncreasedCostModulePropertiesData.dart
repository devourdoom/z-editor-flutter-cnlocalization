import 'package:c_editor/data/pvz_models/PvzModel.dart';

class IncreasedCostModulePropertiesData extends PvzModel {
  IncreasedCostModulePropertiesData({
    this.baseCostIncreased = 25,
    this.maxIncreasedCount = 10,
  });

  int baseCostIncreased;
  int maxIncreasedCount;

  factory IncreasedCostModulePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return IncreasedCostModulePropertiesData(
      baseCostIncreased: json['BaseCostIncreased'] as int? ?? 25,
      maxIncreasedCount: json['MaxIncreasedCount'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
    'BaseCostIncreased': baseCostIncreased,
    'MaxIncreasedCount': maxIncreasedCount,
  };
}
