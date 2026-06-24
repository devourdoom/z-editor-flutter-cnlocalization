import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BowlingMinigamePropertiesData extends PvzModel {
  BowlingMinigamePropertiesData({this.bowlingFoulLine = 2});

  int bowlingFoulLine;

  factory BowlingMinigamePropertiesData.fromJson(Map<String, dynamic> json) {
    return BowlingMinigamePropertiesData(
      bowlingFoulLine: json['BowlingFoulLine'] as int? ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {'BowlingFoulLine': bowlingFoulLine};
}
