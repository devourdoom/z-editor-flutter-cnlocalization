import 'package:c_editor/data/pvz_models/PvzModel.dart';

class MinMaxRange extends PvzModel {
  MinMaxRange({this.min = 0, this.max = 0});

  int min;
  int max;

  factory MinMaxRange.fromJson(Map<String, dynamic> json) {
    return MinMaxRange(
      min: (json['Min'] as num?)?.toInt() ?? 0,
      max: (json['Max'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'Min': min, 'Max': max};
}
