import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/BarrelParamsData.dart';

class BarrelEntryData extends PvzModel {
  BarrelEntryData({required this.row, required this.type, this.params});

  /// 1-based row (1–5 standard, 1–6 Deep Sea)
  int row;

  /// barrelempty | barrelmoster | barrelexplosive
  String type;
  BarrelParamsData? params;

  factory BarrelEntryData.fromJson(Map<String, dynamic> json) {
    final paramsRaw = json['Params'];
    var type = json['Type'] as String? ?? 'barrelempty';
    if (type == 'barrelexplosive')
      type = 'barrelpowder'; // Normalize legacy type
    return BarrelEntryData(
      row: json['Row'] as int? ?? 1,
      type: type,
      params: paramsRaw is Map<String, dynamic>
          ? BarrelParamsData.fromJson(paramsRaw)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{'Row': row, 'Type': type};
    if (params != null) m['Params'] = params!.toJson();
    return m;
  }
}
