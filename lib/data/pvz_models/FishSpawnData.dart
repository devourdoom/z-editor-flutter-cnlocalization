import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/FishPositionData.dart';

class FishSpawnData extends PvzModel {
  FishSpawnData({this.type = '', FishPositionData? position})
    : position = position ?? FishPositionData();

  String type;
  FishPositionData position;

  factory FishSpawnData.fromJson(Map<String, dynamic> json) {
    final pos = json['Position'];
    return FishSpawnData(
      type: json['Type'] as String? ?? '',
      position: pos is Map<String, dynamic>
          ? FishPositionData.fromJson(pos)
          : FishPositionData(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Type': type,
    'Position': position.toJson(),
  };
}
