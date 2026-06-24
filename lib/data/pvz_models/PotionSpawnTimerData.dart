import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PotionSpawnTimerData extends PvzModel {
  PotionSpawnTimerData({this.min = 12, this.max = 16});

  int min;
  int max;

  factory PotionSpawnTimerData.fromJson(Map<String, dynamic> json) {
    return PotionSpawnTimerData(
      min: json['Min'] as int? ?? 12,
      max: json['Max'] as int? ?? 16,
    );
  }

  Map<String, dynamic> toJson() => {'Min': min, 'Max': max};
}
