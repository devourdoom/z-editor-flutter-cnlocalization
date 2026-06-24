import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeSimultaneousPlantsData extends PvzModel {
  StarChallengeSimultaneousPlantsData({this.maximumPlants = 10});
  int maximumPlants;
  factory StarChallengeSimultaneousPlantsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return StarChallengeSimultaneousPlantsData(
      maximumPlants: json['MaximumPlants'] as int? ?? 10,
    );
  }
  Map<String, dynamic> toJson() => {'MaximumPlants': maximumPlants};
}
