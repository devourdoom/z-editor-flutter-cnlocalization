import 'package:c_editor/data/pvz_models/PvzModel.dart';

class DinoTreadActionPropsData extends PvzModel {
  DinoTreadActionPropsData({
    this.gridY = 0,
    this.gridXMin = 0,
    this.gridXMax = 4,
    this.timeInterval = 2,
    this.waveStartMessage = '[WARNING_DINO_TREAD]',
  });

  int gridY;
  int gridXMin;
  int gridXMax;
  int timeInterval;
  String waveStartMessage;

  factory DinoTreadActionPropsData.fromJson(Map<String, dynamic> json) {
    return DinoTreadActionPropsData(
      gridY: parseIntSafe(json['GridY']) ?? 0,
      gridXMin: parseIntSafe(json['GridXMin']) ?? 0,
      gridXMax: parseIntSafe(json['GridXMax']) ?? 4,
      timeInterval: parseIntSafe(json['TimeInterval']) ?? 2,
      waveStartMessage:
          json['WaveStartMessage'] as String? ?? '[WARNING_DINO_TREAD]',
    );
  }

  static int? parseIntSafe(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  Map<String, dynamic> toJson() => {
    'GridY': gridY,
    'GridXMin': gridXMin,
    'GridXMax': gridXMax,
    'TimeInterval': timeInterval,
    'WaveStartMessage': waveStartMessage,
  };
}
