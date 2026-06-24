import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/FrostWindData.dart';

class FrostWindWaveActionPropsData extends PvzModel {
  FrostWindWaveActionPropsData({this.winds = const []});

  List<FrostWindData> winds;

  factory FrostWindWaveActionPropsData.fromJson(Map<String, dynamic> json) {
    return FrostWindWaveActionPropsData(
      winds:
          (json['Winds'] as List<dynamic>?)
              ?.map((e) => FrostWindData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Winds': winds.map((e) => e.toJson()).toList(),
  };
}
