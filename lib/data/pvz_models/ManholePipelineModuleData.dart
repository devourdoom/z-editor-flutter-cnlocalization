import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/PipelineData.dart';

class ManholePipelineModuleData extends PvzModel {
  ManholePipelineModuleData({
    this.operationTimePerGrid = 1,
    this.damagePerSecond = 30,
    this.pipelineList = const [],
  });

  int operationTimePerGrid;
  int damagePerSecond;
  List<PipelineData> pipelineList;

  factory ManholePipelineModuleData.fromJson(Map<String, dynamic> json) {
    return ManholePipelineModuleData(
      operationTimePerGrid: json['OperationTimePerGrid'] as int? ?? 1,
      damagePerSecond: json['DamagePerSecond'] as int? ?? 30,
      pipelineList:
          (json['PipelineList'] as List<dynamic>?)
              ?.map((e) => PipelineData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'OperationTimePerGrid': operationTimePerGrid,
    'DamagePerSecond': damagePerSecond,
    'PipelineList': pipelineList.map((e) => e.toJson()).toList(),
  };
}
