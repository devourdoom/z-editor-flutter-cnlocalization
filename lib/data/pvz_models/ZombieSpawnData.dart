import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ZombieSpawnData extends PvzModel {
  ZombieSpawnData({this.type = '', this.level, this.row, this.direction});

  String type;
  int? level;
  int? row;

  /// Direction zombie comes from: "left" or "right". Null = right (game default).
  String? direction;

  factory ZombieSpawnData.fromJson(Map<String, dynamic> json) {
    return ZombieSpawnData(
      type: json['Type'] as String? ?? '',
      level: json['Level'] as int?,
      row: json['Row'] as int?,
      direction: json['Direction'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'Type': type};
    if (level != null) data['Level'] = level;
    if (row != null) data['Row'] = row;
    if (direction != null) data['Direction'] = direction;
    return data;
  }
}
