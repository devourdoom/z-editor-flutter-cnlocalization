import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RiftTimedSunData extends PvzModel {
  RiftTimedSunData({this.zombieTypeName = '', List<int>? sunDropValues})
    : sunDropValues = sunDropValues ?? List.filled(10, 0);

  String zombieTypeName;
  List<int> sunDropValues;

  factory RiftTimedSunData.fromJson(Map<String, dynamic> json) {
    final raw = json['SunDropValues'] as List<dynamic>? ?? [];
    final values = raw.map((e) => (e is num) ? e.toInt() : 0).toList();
    while (values.length < 10) {
      values.add(0);
    }
    return RiftTimedSunData(
      zombieTypeName: json['ZombieTypeName'] as String? ?? '',
      sunDropValues: values.take(10).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'ZombieTypeName': zombieTypeName,
    'SunDropValues': sunDropValues,
  };
}
