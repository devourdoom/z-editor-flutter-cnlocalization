import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/LocationData.dart';

class ZombiePotionData extends PvzModel {
  ZombiePotionData({LocationData? location, this.type = ''})
    : location = location ?? LocationData();

  LocationData location;
  String type;

  factory ZombiePotionData.fromJson(Map<String, dynamic> json) {
    return ZombiePotionData(
      location: LocationData.fromJson(
        json['Location'] as Map<String, dynamic>? ?? {},
      ),
      type: json['Type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Location': location.toJson(),
    'Type': type,
  };
}
