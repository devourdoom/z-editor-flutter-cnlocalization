import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ZombieTypeData extends PvzModel {
  ZombieTypeData({this.typeName = '', this.properties = '', this.resistences});

  String typeName;
  String properties;
  List<double>? resistences;

  factory ZombieTypeData.fromJson(Map<String, dynamic> json) {
    return ZombieTypeData(
      typeName: json['TypeName'] as String? ?? '',
      properties: json['Properties'] as String? ?? '',
      resistences: (json['Resistences'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'TypeName': typeName,
    'Properties': properties,
    if (resistences != null) 'Resistences': resistences,
  };
}
