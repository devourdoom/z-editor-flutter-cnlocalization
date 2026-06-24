import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/InitialGridItemData.dart';

class InitialGridItemEntryData extends PvzModel {
  InitialGridItemEntryData({this.placements = const []});

  List<InitialGridItemData> placements;

  factory InitialGridItemEntryData.fromJson(Map<String, dynamic> json) {
    return InitialGridItemEntryData(
      placements:
          (json['InitialGridItemPlacements'] as List<dynamic>?)
              ?.map(
                (e) => InitialGridItemData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'InitialGridItemPlacements': placements.map((e) => e.toJson()).toList(),
  };
}
