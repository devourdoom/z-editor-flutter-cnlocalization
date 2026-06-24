import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/InitialZombieData.dart';

class InitialZombieEntryData extends PvzModel {
  InitialZombieEntryData({this.placements = const []});

  List<InitialZombieData> placements;

  factory InitialZombieEntryData.fromJson(Map<String, dynamic> json) {
    return InitialZombieEntryData(
      placements:
          (json['InitialZombiePlacements'] as List<dynamic>?)
              ?.map(
                (e) => InitialZombieData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'InitialZombiePlacements': placements.map((e) => e.toJson()).toList(),
  };
}
