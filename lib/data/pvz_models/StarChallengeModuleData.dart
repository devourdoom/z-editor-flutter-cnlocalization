import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeModuleData extends PvzModel {
  StarChallengeModuleData({
    this.challengesAlwaysAvailable = true,
    List<dynamic>? challenges,
  }) : challenges = challenges ?? [];

  bool challengesAlwaysAvailable;
  List<dynamic> challenges; // Can be any challenge type

  factory StarChallengeModuleData.fromJson(Map<String, dynamic> json) {
    return StarChallengeModuleData(
      challengesAlwaysAvailable:
          json['ChallengesAlwaysAvailable'] as bool? ?? true,
      challenges: List<dynamic>.from(
        json['Challenges'] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'ChallengesAlwaysAvailable': challengesAlwaysAvailable,
    'Challenges': challenges,
  };
}
