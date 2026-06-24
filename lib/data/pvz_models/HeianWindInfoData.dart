import 'package:c_editor/data/pvz_models/PvzModel.dart';

class HeianWindInfoData extends PvzModel {
  HeianWindInfoData({
    this.row = 0,
    this.affectZombies = 0,
    this.distance = 0,
    this.moveTime = 1.5,
  });

  /// 0-based row index. -1 means all rows.
  int row;
  int affectZombies;
  double distance;
  double moveTime;

  factory HeianWindInfoData.fromJson(Map<String, dynamic> json) {
    return HeianWindInfoData(
      row: (json['Row'] as num?)?.toInt() ?? 0,
      affectZombies: (json['AffectZombies'] as num?)?.toInt() ?? 0,
      distance: (json['Distance'] as num?)?.toDouble() ?? 0,
      moveTime: (json['MoveTime'] as num?)?.toDouble() ?? 1.5,
    );
  }

  Map<String, dynamic> toJson() => {
    'Row': row,
    'AffectZombies': affectZombies,
    'Distance': distance,
    'MoveTime': moveTime,
  };
}
