import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/SchoolBusParamsData.dart';

const schoolBusNormalType = 'schoolbus_normal';
const schoolBusSpecialType = 'schoolbus_special';

class SchoolBusDesData extends PvzModel {
  SchoolBusDesData({
    this.row = 1,
    this.type = schoolBusSpecialType,
    SchoolBusParamsData? params,
  }) : params = params ?? SchoolBusParamsData();

  /// 1-based row (1–5 standard, 1–6 Deep Sea).
  int row;

  /// Grid item type: [schoolBusNormalType] or [schoolBusSpecialType].
  String type;
  SchoolBusParamsData params;

  factory SchoolBusDesData.fromJson(Map<String, dynamic> json) {
    final paramsRaw = json['Params'];
    return SchoolBusDesData(
      row: json['Row'] as int? ?? 1,
      type: json['Type'] as String? ?? schoolBusSpecialType,
      params: paramsRaw is Map<String, dynamic>
          ? SchoolBusParamsData.fromJson(paramsRaw)
          : SchoolBusParamsData(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'Row': row, 'Type': type, 'Params': params.toJson()};
  }
}
