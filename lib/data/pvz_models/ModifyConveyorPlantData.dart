import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ModifyConveyorPlantData extends PvzModel {
  ModifyConveyorPlantData({
    this.type = '',
    this.iLevel,
    this.iAvatar,
    this.weight = 100,
    this.maxCount = 0,
    this.maxWeightFactor = 1.0,
    this.minCount = 0,
    this.minWeightFactor = 1.0,
  });

  String type;
  int? iLevel;
  bool? iAvatar;
  int weight;
  int maxCount;
  double maxWeightFactor;
  int minCount;
  double minWeightFactor;

  bool get isToolEntry => type.startsWith('tool_') && !type.startsWith('RTID(');

  factory ModifyConveyorPlantData.fromJson(Map<String, dynamic> json) {
    return ModifyConveyorPlantData(
      type: json['ToolType'] as String? ?? json['Type'] as String? ?? '',
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
    final Map<String, dynamic> data = {
      'Weight': weight,
      'MaxCount': maxCount,
      'MaxWeightFactor': maxWeightFactor,
      'MinCount': minCount,
      'MinWeightFactor': minWeightFactor,
    };
    if (isToolEntry) {
      data['ToolType'] = type;
    } else {
      data['Type'] = type;
      if (iLevel != null) data['iLevel'] = iLevel;
      if (iAvatar != null) data['iAvatar'] = iAvatar;
    }
    return data;
  }
}
