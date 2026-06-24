import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengePlantSurviveData extends PvzModel {
  StarChallengePlantSurviveData({this.count = 10});
  int count;
  factory StarChallengePlantSurviveData.fromJson(Map<String, dynamic> json) {
    return StarChallengePlantSurviveData(count: json['Count'] as int? ?? 10);
  }
  Map<String, dynamic> toJson() => {'Count': count};
}
