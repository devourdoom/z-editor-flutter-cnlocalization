import 'package:c_editor/data/pvz_models/PvzModel.dart';

class DinoWaveActionPropsData extends PvzModel {
  DinoWaveActionPropsData({
    this.dinoRow = 2,
    this.dinoType = 'raptor',
    this.dinoWaveDuration = 2,
  });

  int dinoRow;
  String dinoType;
  int dinoWaveDuration;

  factory DinoWaveActionPropsData.fromJson(Map<String, dynamic> json) {
    return DinoWaveActionPropsData(
      dinoRow: json['DinoRow'] as int? ?? 2,
      dinoType: json['DinoType'] as String? ?? 'raptor',
      dinoWaveDuration: json['DinoWaveDuration'] as int? ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {
    'DinoRow': dinoRow,
    'DinoType': dinoType,
    'DinoWaveDuration': dinoWaveDuration,
  };
}
