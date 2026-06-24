import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PVZ1PassageModulePropertiesData extends PvzModel {
  PVZ1PassageModulePropertiesData({
    this.groupAmount = 2,
    this.passageAmount = 2,
    this.gridXMin = 2,
    this.gridXMax = 8,
    this.transferCooldown = 5,
    this.refreshTime = 15,
  });

  int groupAmount;
  int passageAmount;
  int gridXMin;
  int gridXMax;
  int transferCooldown;
  int refreshTime;

  factory PVZ1PassageModulePropertiesData.fromJson(Map<String, dynamic> json) {
    return PVZ1PassageModulePropertiesData(
      groupAmount: json['GroupAmount'] as int? ?? 2,
      passageAmount: json['PassageAmount'] as int? ?? 2,
      gridXMin: json['GridXMin'] as int? ?? 2,
      gridXMax: json['GridXMax'] as int? ?? 8,
      transferCooldown: json['transferCooldown'] as int? ?? 5,
      refreshTime: json['refreshTime'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() => {
    'GroupAmount': groupAmount,
    'PassageAmount': passageAmount,
    'GridXMin': gridXMin,
    'GridXMax': gridXMax,
    'transferCooldown': transferCooldown,
    'refreshTime': refreshTime,
  };
}
