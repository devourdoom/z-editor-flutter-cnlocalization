import 'package:c_editor/data/pvz_models/PvzModel.dart';

class InitialPlantListData extends PvzModel {
  InitialPlantListData({
    this.plantType = '',
    this.iLevel,
    this.iAvatar,
    this.weight = 100,
    this.maxCount = 0,
    this.maxWeightFactor = 1.0,
    this.minCount = 0,
    this.minWeightFactor = 1.0,
  });

  String plantType;
  int? iLevel;

  /// When true, plant may use a costume on the conveyor card (plant entries only).
  bool? iAvatar;
  int weight;
  int maxCount;
  double maxWeightFactor;
  int minCount;
  double minWeightFactor;

  bool get isToolEntry =>
      plantType.startsWith('tool_') && !plantType.startsWith('RTID(');

  factory InitialPlantListData.fromJson(Map<String, dynamic> json) {
    final tool = json['ToolType'] as String?;
    final plant = json['PlantType'] as String?;
    return InitialPlantListData(
      plantType: tool ?? plant ?? '',
      iLevel: json['iLevel'] as int?,
      iAvatar: json['iAvatar'] as bool?,
      weight: json['Weight'] as int? ?? 100,
      maxCount: json['MaxCount'] as int? ?? 0,
      maxWeightFactor: (json['MaxWeightFactor'] as num?)?.toDouble() ?? 1.0,
      minCount: json['MinCount'] as int? ?? 0,
      minWeightFactor: (json['MinWeightFactor'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'Weight': weight,
      'MaxCount': maxCount,
      'MaxWeightFactor': maxWeightFactor,
      'MinCount': minCount,
      'MinWeightFactor': minWeightFactor,
    };
    if (isToolEntry) {
      m['ToolType'] = plantType;
    } else {
      m['PlantType'] = plantType;
      if (iLevel != null) m['iLevel'] = iLevel;
      if (iAvatar != null) m['iAvatar'] = iAvatar;
    }
    return m;
  }
}
