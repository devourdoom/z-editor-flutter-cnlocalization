import 'package:c_editor/data/pvz_models/PvzModel.dart';

class FrostWindData extends PvzModel {
  FrostWindData({this.direction = 'right', this.row = 2});

  String direction;
  int row;

  factory FrostWindData.fromJson(Map<String, dynamic> json) {
    return FrostWindData(
      direction: json['Direction'] as String? ?? 'right',
      row: json['Row'] as int? ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {'Direction': direction, 'Row': row};
}
