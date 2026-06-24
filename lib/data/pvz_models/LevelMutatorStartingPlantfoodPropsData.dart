import 'package:c_editor/data/pvz_models/PvzModel.dart';

class LevelMutatorStartingPlantfoodPropsData extends PvzModel {
  LevelMutatorStartingPlantfoodPropsData({
    this.startingPlantfoodOverride = 0,
    this.difficultyProps =
        'RTID(LevelModuleDifficultyStartingPlantfood@LevelModulesDifficulty)',
    this.iconImage =
        'IMAGE_UI_PENNY_PURSUITS_DIFFICULTY_MODIFIER_ICONS_DIFFICULTY_MODIFIER_PF',
    this.iconText = '',
  });

  int startingPlantfoodOverride;
  String difficultyProps;
  String iconImage;
  String iconText;

  factory LevelMutatorStartingPlantfoodPropsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return LevelMutatorStartingPlantfoodPropsData(
      startingPlantfoodOverride: json['StartingPlantfoodOverride'] as int? ?? 0,
      difficultyProps:
          json['DifficultyProps'] as String? ??
          'RTID(LevelModuleDifficultyStartingPlantfood@LevelModulesDifficulty)',
      iconImage:
          json['IconImage'] as String? ??
          'IMAGE_UI_PENNY_PURSUITS_DIFFICULTY_MODIFIER_ICONS_DIFFICULTY_MODIFIER_PF',
      iconText: json['IconText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'StartingPlantfoodOverride': startingPlantfoodOverride,
    'DifficultyProps': difficultyProps,
    'IconImage': iconImage,
    'IconText': iconText,
  };
}
