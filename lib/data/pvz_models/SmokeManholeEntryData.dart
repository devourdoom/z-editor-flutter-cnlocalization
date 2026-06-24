import 'package:c_editor/data/pvz_models/PvzModel.dart';

class SmokeManholeEntryData extends PvzModel {
  SmokeManholeEntryData({
    required this.gridColumn,
    required this.gridRow,
    this.startTime = 0,
  });

  int gridColumn;
  int gridRow;
  int startTime;

  factory SmokeManholeEntryData.fromJson(Map<String, dynamic> json) {
    return SmokeManholeEntryData(
      gridColumn: (json['GridColumn'] as num?)?.toInt() ?? 0,
      gridRow: (json['GridRow'] as num?)?.toInt() ?? 0,
      startTime: (json['StartTime'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'GridColumn': gridColumn,
    'GridRow': gridRow,
    'StartTime': startTime,
  };
}
