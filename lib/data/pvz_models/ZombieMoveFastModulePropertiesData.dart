import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ZombieMoveFastModulePropertiesData extends PvzModel {
  ZombieMoveFastModulePropertiesData({this.stopColumn = 6, this.speedUp = 3.0});

  int stopColumn;
  double speedUp;

  factory ZombieMoveFastModulePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ZombieMoveFastModulePropertiesData(
      stopColumn: json['StopColumn'] as int? ?? 6,
      speedUp: (json['SpeedUp'] as num?)?.toDouble() ?? 3.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'StopColumn': stopColumn,
    'SpeedUp': speedUp,
  };
}
