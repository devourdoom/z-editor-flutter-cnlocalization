import 'package:c_editor/data/pvz_models/PvzModel.dart';

class Point3DDouble extends PvzModel {
  Point3DDouble({this.x = 0.0, this.y = 0.0, this.z = 0.0});

  double x;
  double y;
  double z;

  factory Point3DDouble.fromJson(Map<String, dynamic> json) {
    return Point3DDouble(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      z: (json['z'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
}
