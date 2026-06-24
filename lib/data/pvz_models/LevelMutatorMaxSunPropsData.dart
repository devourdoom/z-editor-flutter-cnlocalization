import 'package:c_editor/data/pvz_models/PvzModel.dart';

class LevelMutatorMaxSunPropsData extends PvzModel {
  LevelMutatorMaxSunPropsData({
    this.maxSunOverride = 9900,
    this.difficultyProps =
        'RTID(LevelModuleDifficultyMaxSun@LevelModulesDifficulty)',
    this.iconImage =
        'IMAGE_UI_PENNY_PURSUITS_DIFFICULTY_MODIFIER_ICONS_DIFFICULTY_MODIFIER_STARTING_SUN',
    this.iconText = '',
  });

  int maxSunOverride;
  String difficultyProps;
  String iconImage;
  String iconText;

  factory LevelMutatorMaxSunPropsData.fromJson(Map<String, dynamic> json) {
    return LevelMutatorMaxSunPropsData(
      maxSunOverride: json['MaxSunOverride'] as int? ?? 9900,
      difficultyProps:
          json['DifficultyProps'] as String? ??
          'RTID(LevelModuleDifficultyMaxSun@LevelModulesDifficulty)',
      iconImage:
          json['IconImage'] as String? ??
          'IMAGE_UI_PENNY_PURSUITS_DIFFICULTY_MODIFIER_ICONS_DIFFICULTY_MODIFIER_STARTING_SUN',
      iconText: json['IconText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'MaxSunOverride': maxSunOverride,
    'DifficultyProps': difficultyProps,
    'IconImage': iconImage,
    'IconText': iconText,
  };
}
