import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/InitialPlantPlacementData.dart';

class InitialPlantPropertiesData extends PvzModel {
  InitialPlantPropertiesData({
    this.placements = const [],
    this.isInitialIntensiveCarrotPlacements,
  });

  List<InitialPlantPlacementData> placements;
  bool? isInitialIntensiveCarrotPlacements;

  factory InitialPlantPropertiesData.fromJson(Map<String, dynamic> json) {
    return InitialPlantPropertiesData(
      placements:
          (json['InitialPlantPlacements'] as List<dynamic>?)
              ?.map(
                (e) => InitialPlantPlacementData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      isInitialIntensiveCarrotPlacements:
          json['IsInitialIntensiveCarrotPlacements'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'InitialPlantPlacements': placements.map((e) => e.toJson()).toList(),
    if (isInitialIntensiveCarrotPlacements != null)
      'IsInitialIntensiveCarrotPlacements': isInitialIntensiveCarrotPlacements,
  };
}
