import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/SmokeManholeEntryData.dart';

class SmokePollutionModulePropertiesData extends PvzModel {
  SmokePollutionModulePropertiesData({
    List<SmokeManholeEntryData>? smokeManholeList,
    this.gridItem = gridItemType,
  }) : smokeManholeList = smokeManholeList ?? [];

  static const gridItemType = 'SmokeManhole';

  List<SmokeManholeEntryData> smokeManholeList;
  String gridItem;

  factory SmokePollutionModulePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return SmokePollutionModulePropertiesData(
      gridItem: json['GridItem'] as String? ?? gridItemType,
      smokeManholeList:
          (json['SmokeManholeList'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SmokeManholeEntryData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'GridItem': gridItem,
    if (smokeManholeList.isNotEmpty)
      'SmokeManholeList': smokeManholeList.map((e) => e.toJson()).toList(),
  };
}
