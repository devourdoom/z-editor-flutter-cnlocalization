import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PipelineData extends PvzModel {
  PipelineData({
    this.startX = 0,
    this.startY = 0,
    this.endX = 0,
    this.endY = 0,
  });

  int startX;
  int startY;
  int endX;
  int endY;

  factory PipelineData.fromJson(Map<String, dynamic> json) {
    return PipelineData(
      startX: json['StartX'] as int? ?? 0,
      startY: json['StartY'] as int? ?? 0,
      endX: json['EndX'] as int? ?? 0,
      endY: json['EndY'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'StartX': startX,
    'StartY': startY,
    'EndX': endX,
    'EndY': endY,
  };
}
