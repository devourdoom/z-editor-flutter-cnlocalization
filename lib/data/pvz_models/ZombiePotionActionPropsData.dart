import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/ZombiePotionData.dart';

class ZombiePotionActionPropsData extends PvzModel {
  ZombiePotionActionPropsData({this.potions = const []});

  List<ZombiePotionData> potions;

  factory ZombiePotionActionPropsData.fromJson(Map<String, dynamic> json) {
    return ZombiePotionActionPropsData(
      potions:
          (json['Potions'] as List<dynamic>?)
              ?.map((e) => ZombiePotionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Potions': potions.map((e) => e.toJson()).toList(),
  };
}
