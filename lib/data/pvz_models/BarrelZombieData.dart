import 'package:c_editor/data/pvz_models/PvzModel.dart';

class BarrelZombieData extends PvzModel {
  BarrelZombieData({this.typeName = '', this.level = 1});

  String typeName;
  int level;

  factory BarrelZombieData.fromJson(Map<String, dynamic> json) {
    return BarrelZombieData(
      typeName: json['TypeName'] as String? ?? '',
      level: json['Level'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {'TypeName': typeName, 'Level': level};
}

/// Thunder type: positive or negative
