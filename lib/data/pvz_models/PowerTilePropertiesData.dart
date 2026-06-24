import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/LinkedTileData.dart';

class PowerTilePropertiesData extends PvzModel {
  PowerTilePropertiesData({this.linkedTiles = const []});

  List<LinkedTileData> linkedTiles;

  factory PowerTilePropertiesData.fromJson(Map<String, dynamic> json) {
    return PowerTilePropertiesData(
      linkedTiles:
          (json['LinkedTiles'] as List<dynamic>?)
              ?.map((e) => LinkedTileData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'LinkedTiles': linkedTiles.map((e) => e.toJson()).toList(),
  };
}
