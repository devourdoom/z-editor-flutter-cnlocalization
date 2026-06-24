import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SpeedConditionData extends PvzModel {
  SpeedConditionData({this.speed = 0, this.maxPacketsSpeed = 0});

  int speed;
  int maxPacketsSpeed;

  factory SpeedConditionData.fromJson(Map<String, dynamic> json) {
    return SpeedConditionData(
      speed: json['Speed'] as int? ?? 0,
      maxPacketsSpeed: json['MaxPackets'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'Speed': speed,
    'MaxPackets': maxPacketsSpeed,
  };
}
