import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ParachuteRainEventData extends PvzModel {
  ParachuteRainEventData({
    this.columnStart = 5,
    this.columnEnd = 9,
    this.groupSize = 1,
    this.spiderCount = 1,
    this.spiderZombieName = '',
    this.timeBeforeFullSpawn = 1.0,
    this.timeBetweenGroups = 1.5,
    this.zombieFallTime = 4.5,
    this.waveStartMessage = '',
  });

  int columnStart;
  int columnEnd;
  int groupSize;
  int spiderCount;
  String spiderZombieName;
  double timeBeforeFullSpawn;
  double timeBetweenGroups;
  double zombieFallTime;
  String waveStartMessage;

  factory ParachuteRainEventData.fromJson(Map<String, dynamic> json) {
    return ParachuteRainEventData(
      columnStart: json['ColumnStart'] as int? ?? 5,
      columnEnd: json['ColumnEnd'] as int? ?? 9,
      groupSize: json['GroupSize'] as int? ?? 1,
      spiderCount: json['SpiderCount'] as int? ?? 1,
      spiderZombieName: json['SpiderZombieName'] as String? ?? '',
      timeBeforeFullSpawn:
          (json['TimeBeforeFullSpawn'] as num?)?.toDouble() ?? 1.0,
      timeBetweenGroups: (json['TimeBetweenGroups'] as num?)?.toDouble() ?? 1.5,
      zombieFallTime: (json['ZombieFallTime'] as num?)?.toDouble() ?? 4.5,
      waveStartMessage: json['WaveStartMessage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'ColumnStart': columnStart,
    'ColumnEnd': columnEnd,
    'GroupSize': groupSize,
    'SpiderCount': spiderCount,
    'SpiderZombieName': spiderZombieName,
    'TimeBeforeFullSpawn': timeBeforeFullSpawn,
    'TimeBetweenGroups': timeBetweenGroups,
    'ZombieFallTime': zombieFallTime,
    'WaveStartMessage': waveStartMessage,
  };
}
