import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/MagicMirrorArrayData.dart';

class MagicMirrorWaveActionData extends PvzModel {
  MagicMirrorWaveActionData({this.arrays = const []});

  List<MagicMirrorArrayData> arrays;

  factory MagicMirrorWaveActionData.fromJson(Map<String, dynamic> json) {
    return MagicMirrorWaveActionData(
      arrays:
          (json['MagicMirrorTeleportationArrays'] as List<dynamic>?)
              ?.map(
                (e) => MagicMirrorArrayData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'MagicMirrorTeleportationArrays': arrays.map((e) => e.toJson()).toList(),
  };
}
