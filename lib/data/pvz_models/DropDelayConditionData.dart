import 'package:c_editor/data/pvz_models/PvzModel.dart';

class DropDelayConditionData extends PvzModel {
  DropDelayConditionData({this.delay = 0, this.maxPacketsDelay = 0});

  int delay;
  int maxPacketsDelay;

  factory DropDelayConditionData.fromJson(Map<String, dynamic> json) {
    return DropDelayConditionData(
      delay: json['Delay'] as int? ?? 0,
      maxPacketsDelay: json['MaxPackets'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'Delay': delay,
    'MaxPackets': maxPacketsDelay,
  };
}
