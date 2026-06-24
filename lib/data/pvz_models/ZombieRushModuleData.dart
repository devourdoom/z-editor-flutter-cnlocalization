import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ZombieRushModuleData extends PvzModel {
  ZombieRushModuleData({
    this.timeCountDown = 120.0,
    this.plantBlackList = const [],
  });

  double timeCountDown;
  List<int> plantBlackList;

  factory ZombieRushModuleData.fromJson(Map<String, dynamic> json) {
    return ZombieRushModuleData(
      timeCountDown: (json['TimeCountDown'] as num?)?.toDouble() ?? 120.0,
      plantBlackList:
          (json['PlantBlackList'] as List<dynamic>?)?.cast<int>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'TimeCountDown': timeCountDown,
    if (plantBlackList.isNotEmpty) 'PlantBlackList': plantBlackList,
  };
}
