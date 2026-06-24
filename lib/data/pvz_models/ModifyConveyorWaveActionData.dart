import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ModifyConveyorPlantData.dart';
import 'package:c_editor/data/pvz_models/ModifyConveyorRemoveData.dart';

class ModifyConveyorWaveActionData extends PvzModel {
  ModifyConveyorWaveActionData({
    this.addList = const [],
    this.removeList = const [],
  });

  List<ModifyConveyorPlantData> addList;
  List<ModifyConveyorRemoveData> removeList;

  factory ModifyConveyorWaveActionData.fromJson(Map<String, dynamic> json) {
    return ModifyConveyorWaveActionData(
      addList:
          (json['Add'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ModifyConveyorPlantData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      removeList:
          (json['Remove'] as List<dynamic>?)
              ?.map(
                (e) => ModifyConveyorRemoveData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Add': addList.map((e) => e.toJson()).toList(),
    'Remove': removeList.map((e) => e.toJson()).toList(),
  };
}
