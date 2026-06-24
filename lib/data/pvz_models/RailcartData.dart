import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RailcartData extends PvzModel {
  RailcartData({this.column = 0, this.row = 0});

  int column;
  int row;

  factory RailcartData.fromJson(Map<String, dynamic> json) {
    return RailcartData(
      column: json['Column'] as int? ?? 0,
      row: json['Row'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'Column': column, 'Row': row};
}
