import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ArmrackOverrideItemData.dart';

class ArmrackOverrideWaveData extends PvzModel {
  ArmrackOverrideWaveData({
    this.wave = 1,
    List<ArmrackOverrideItemData>? itemList,
  }) : itemList = itemList ?? [];

  int wave;
  List<ArmrackOverrideItemData> itemList;

  factory ArmrackOverrideWaveData.fromJson(Map<String, dynamic> json) {
    final list = json['itemList'] as List<dynamic>?;
    return ArmrackOverrideWaveData(
      wave: (json['wave'] as num?)?.toInt() ?? 1,
      itemList:
          list
              ?.map(
                (e) =>
                    ArmrackOverrideItemData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'wave': wave,
    'itemList': itemList.map((e) => e.toJson()).toList(),
  };
}
