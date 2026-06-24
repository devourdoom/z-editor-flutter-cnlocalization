import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/LocationData.dart';

class AtlantisShellTileData extends PvzModel {
  AtlantisShellTileData({LocationData? location, this.type = 'atlantis_shell'})
    : location = location ?? LocationData();

  LocationData location;
  String type;

  factory AtlantisShellTileData.fromJson(Map<String, dynamic> json) {
    return AtlantisShellTileData(
      location: LocationData.fromJson(
        json['Location'] as Map<String, dynamic>? ?? {},
      ),
      type: json['Type'] as String? ?? 'atlantis_shell',
    );
  }

  Map<String, dynamic> toJson() => {
    'Location': location.toJson(),
    'Type': type,
  };
}
