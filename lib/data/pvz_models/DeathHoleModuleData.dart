import 'package:c_editor/data/pvz_models/PvzModel.dart';

class DeathHoleModuleData extends PvzModel {
  DeathHoleModuleData({this.lifeTime = 10});

  int lifeTime;

  factory DeathHoleModuleData.fromJson(Map<String, dynamic> json) {
    return DeathHoleModuleData(lifeTime: json['LifeTime'] as int? ?? 10);
  }

  Map<String, dynamic> toJson() => {'LifeTime': lifeTime};
}
