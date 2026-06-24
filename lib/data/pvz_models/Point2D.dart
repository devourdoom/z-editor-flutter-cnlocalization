import 'package:c_editor/data/pvz_models/PvzModel.dart';

class Point2D extends PvzModel {
  Point2D({this.x = 0, this.y = 0});

  int x;
  int y;

  factory Point2D.fromJson(Map<String, dynamic> json) {
    return Point2D(x: json['x'] as int? ?? 0, y: json['y'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
