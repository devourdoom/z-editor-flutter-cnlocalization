import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ProtectGridItemData.dart';

class ProtectTheGridItemChallengePropertiesData extends PvzModel {
  ProtectTheGridItemChallengePropertiesData({
    this.description = '',
    this.mustProtectCount = 0,
    this.gridItems = const [],
  });

  String description;
  int mustProtectCount;
  List<ProtectGridItemData> gridItems;

  factory ProtectTheGridItemChallengePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProtectTheGridItemChallengePropertiesData(
      description: json['Description'] as String? ?? '',
      mustProtectCount: json['MustProtectCount'] as int? ?? 0,
      gridItems:
          (json['GridItems'] as List<dynamic>?)
              ?.map(
                (e) => ProtectGridItemData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Description': description,
    'MustProtectCount': mustProtectCount,
    'GridItems': gridItems.map((e) => e.toJson()).toList(),
  };
}
