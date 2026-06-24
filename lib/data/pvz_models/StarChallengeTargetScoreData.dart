import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeTargetScoreData extends PvzModel {
  StarChallengeTargetScoreData({
    this.description = '[STARCHALLENGE_TARGET_SCORE]',
    this.descriptionFailure = '[STARCHALLENGE_TARGET_SCORE_FAILURE]',
    this.descriptiveName = '[STARCHALLENGE_TARGET_SCORE_NAME]',
    this.targetScore = 20000,
  });
  String description;
  String descriptionFailure;
  String descriptiveName;
  int targetScore;
  factory StarChallengeTargetScoreData.fromJson(Map<String, dynamic> json) {
    return StarChallengeTargetScoreData(
      description:
          json['Description'] as String? ?? '[STARCHALLENGE_TARGET_SCORE]',
      descriptionFailure:
          json['DescriptionFailure'] as String? ??
          '[STARCHALLENGE_TARGET_SCORE_FAILURE]',
      descriptiveName:
          json['DescriptiveName'] as String? ??
          '[STARCHALLENGE_TARGET_SCORE_NAME]',
      targetScore: json['TargetScore'] as int? ?? 20000,
    );
  }
  Map<String, dynamic> toJson() => {
    'Description': description,
    'DescriptionFailure': descriptionFailure,
    'DescriptiveName': descriptiveName,
    'TargetScore': targetScore,
  };
}
