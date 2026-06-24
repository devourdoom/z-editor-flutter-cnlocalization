import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BeachStageEventData extends PvzModel {
  BeachStageEventData({
    this.columnStart = 5,
    this.columnEnd = 9,
    this.groupSize = 1,
    this.zombieCount = 1,
    this.zombieName = 'beach',
    this.timeBeforeFullSpawn = 1.0,
    this.timeBetweenGroups = 0.5,
    this.waveStartMessage = '',
  });

  int columnStart;
  int columnEnd;
  int groupSize;
  int zombieCount;
  String zombieName;
  double timeBeforeFullSpawn;
  double timeBetweenGroups;
  String waveStartMessage;

  factory BeachStageEventData.fromJson(Map<String, dynamic> json) {
    return BeachStageEventData(
      columnStart: json['ColumnStart'] as int? ?? 5,
      columnEnd: json['ColumnEnd'] as int? ?? 9,
      groupSize: json['GroupSize'] as int? ?? 1,
      zombieCount: json['ZombieCount'] as int? ?? 1,
      zombieName: json['ZombieName'] as String? ?? 'beach',
      timeBeforeFullSpawn:
          (json['TimeBeforeFullSpawn'] as num?)?.toDouble() ?? 1.0,
      timeBetweenGroups: (json['TimeBetweenGroups'] as num?)?.toDouble() ?? 0.5,
      waveStartMessage: json['WaveStartMessage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'ColumnStart': columnStart,
    'ColumnEnd': columnEnd,
    'GroupSize': groupSize,
    'ZombieCount': zombieCount,
    'ZombieName': zombieName,
    'TimeBeforeFullSpawn': timeBeforeFullSpawn,
    'TimeBetweenGroups': timeBetweenGroups,
    'WaveStartMessage': waveStartMessage,
  };
}
