import 'package:c_editor/data/pvz_models/PvzModel.dart';

class EvilDavePropertiesData extends PvzModel {
  EvilDavePropertiesData({this.plantDistance = 4});

  int plantDistance;

  factory EvilDavePropertiesData.fromJson(Map<String, dynamic> json) {
    return EvilDavePropertiesData(
      plantDistance: json['PlantDistance'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toJson() => {'PlantDistance': plantDistance};
}
