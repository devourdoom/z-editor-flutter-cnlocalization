import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/StormZombieData.dart';

class StormZombieSpawnerPropsData extends PvzModel {
  StormZombieSpawnerPropsData({
    this.columnStart = 5,
    this.columnEnd = 9,
    this.groupSize = 1,
    this.timeBetweenGroups = 1,
    this.type = 'sandstorm',
    this.zombies = const [],
  });

  int columnStart;
  int columnEnd;
  int groupSize;
  int timeBetweenGroups;
  String type;
  List<StormZombieData> zombies;

  factory StormZombieSpawnerPropsData.fromJson(Map<String, dynamic> json) {
    return StormZombieSpawnerPropsData(
      columnStart: json['ColumnStart'] as int? ?? 5,
      columnEnd: json['ColumnEnd'] as int? ?? 9,
      groupSize: json['GroupSize'] as int? ?? 1,
      timeBetweenGroups: json['TimeBetweenGroups'] as int? ?? 1,
      type: json['Type'] as String? ?? 'sandstorm',
      zombies:
          (json['Zombies'] as List<dynamic>?)?.map((e) {
            if (e is Map<String, dynamic>) {
              return StormZombieData.fromJson(e);
            }
            if (e is String) {
              return StormZombieData(type: e);
            }
            return StormZombieData();
          }).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'ColumnStart': columnStart,
    'ColumnEnd': columnEnd,
    'GroupSize': groupSize,
    'TimeBetweenGroups': timeBetweenGroups,
    'Type': type,
    'Zombies': zombies.map((e) => e.toJson()).toList(),
  };
}
