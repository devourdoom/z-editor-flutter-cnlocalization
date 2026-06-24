import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BlackHoleEventData extends PvzModel {
  BlackHoleEventData({this.colNumPlantIsDragged = 0});

  int colNumPlantIsDragged;

  factory BlackHoleEventData.fromJson(Map<String, dynamic> json) {
    return BlackHoleEventData(
      colNumPlantIsDragged: json['ColNumPlantIsDragged'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'ColNumPlantIsDragged': colNumPlantIsDragged,
  };
}
