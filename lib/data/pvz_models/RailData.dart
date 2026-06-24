import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RailData extends PvzModel {
  RailData({this.column = 0, this.rowStart = 0, this.rowEnd = 0});

  int column;
  int rowStart;
  int rowEnd;

  factory RailData.fromJson(Map<String, dynamic> json) {
    return RailData(
      column: json['Column'] as int? ?? 0,
      rowStart: json['RowStart'] as int? ?? 0,
      rowEnd: json['RowEnd'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'Column': column,
    'RowStart': rowStart,
    'RowEnd': rowEnd,
  };
}
