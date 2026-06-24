import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeKillZombiesInTimeData extends PvzModel {
  StarChallengeKillZombiesInTimeData({this.zombiesToKill = 10, this.time = 10});
  int zombiesToKill;
  int time;
  factory StarChallengeKillZombiesInTimeData.fromJson(
    Map<String, dynamic> json,
  ) {
    return StarChallengeKillZombiesInTimeData(
      zombiesToKill: json['ZombiesToKill'] as int? ?? 10,
      time: json['Time'] as int? ?? 10,
    );
  }
  Map<String, dynamic> toJson() => {
    'ZombiesToKill': zombiesToKill,
    'Time': time,
  };
}
