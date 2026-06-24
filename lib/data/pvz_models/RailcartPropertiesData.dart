import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/RailData.dart';
import 'package:c_editor/data/pvz_models/RailcartData.dart';

class RailcartPropertiesData extends PvzModel {
  RailcartPropertiesData({
    this.railcartType = 'railcart_cowboy',
    this.railcarts = const [],
    this.rails = const [],
  });

  String railcartType;
  List<RailcartData> railcarts;
  List<RailData> rails;

  factory RailcartPropertiesData.fromJson(Map<String, dynamic> json) {
    return RailcartPropertiesData(
      railcartType: json['RailcartType'] as String? ?? 'railcart_cowboy',
      railcarts:
          (json['Railcarts'] as List<dynamic>?)
              ?.map((e) => RailcartData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rails:
          (json['Rails'] as List<dynamic>?)
              ?.map((e) => RailData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'RailcartType': railcartType,
    'Railcarts': railcarts.map((e) => e.toJson()).toList(),
    'Rails': rails.map((e) => e.toJson()).toList(),
  };
}
