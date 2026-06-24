import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RenaiStatueInfoData extends PvzModel {
  RenaiStatueInfoData({
    this.gridX = 0,
    this.gridY = 0,
    this.waveNumber = 0,
    this.typeName = '',
  });

  int gridX;
  int gridY;
  int waveNumber;
  String typeName;

  factory RenaiStatueInfoData.fromJson(Map<String, dynamic> json) {
    return RenaiStatueInfoData(
      gridX: (json['GridX'] as num?)?.toInt() ?? 0,
      gridY: (json['GridY'] as num?)?.toInt() ?? 0,
      waveNumber: (json['WaveNumber'] as num?)?.toInt() ?? 0,
      typeName: json['TypeName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'GridX': gridX,
    'GridY': gridY,
    'WaveNumber': waveNumber,
    'TypeName': typeName,
  };
}
