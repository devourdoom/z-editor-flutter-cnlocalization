import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StormZombieData extends PvzModel {
  StormZombieData({this.type = '', this.level});

  String type;

  /// Zombie level (1-10). Elite zombies use null. Game supports this for storm spawns.
  int? level;

  factory StormZombieData.fromJson(Map<String, dynamic> json) {
    return StormZombieData(
      type: json['Type'] as String? ?? '',
      level: json['Level'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{'Type': type};
    if (level != null) m['Level'] = level!;
    return m;
  }
}
