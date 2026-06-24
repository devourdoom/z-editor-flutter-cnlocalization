import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/AtlantisShellTileData.dart';

class ZombieAtlantisShellActionPropsData extends PvzModel {
  ZombieAtlantisShellActionPropsData({this.tiles = const []});

  List<AtlantisShellTileData> tiles;

  factory ZombieAtlantisShellActionPropsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ZombieAtlantisShellActionPropsData(
      tiles:
          (json['Tiles'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AtlantisShellTileData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Tiles': tiles.map((e) => e.toJson()).toList(),
  };
}
