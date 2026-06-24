import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PennyClassroomModuleData extends PvzModel {
  PennyClassroomModuleData({this.plantMap = const {}});

  Map<String, int> plantMap;

  factory PennyClassroomModuleData.fromJson(Map<String, dynamic> json) {
    final raw = json['PlantMap'] as Map<String, dynamic>? ?? {};
    return PennyClassroomModuleData(
      plantMap: raw.map(
        (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
      ),
    );
  }

  Map<String, dynamic> toJson() => {'PlantMap': plantMap};
}
