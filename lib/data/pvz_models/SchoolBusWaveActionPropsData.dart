import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/SchoolBusDesData.dart';

class SchoolBusWaveActionPropsData extends PvzModel {
  SchoolBusWaveActionPropsData({SchoolBusDesData? des})
    : des = des ?? SchoolBusDesData();

  SchoolBusDesData des;

  factory SchoolBusWaveActionPropsData.fromJson(Map<String, dynamic> json) {
    final desRaw = json['Des'];
    return SchoolBusWaveActionPropsData(
      des: desRaw is Map<String, dynamic>
          ? SchoolBusDesData.fromJson(desRaw)
          : SchoolBusDesData(),
    );
  }

  Map<String, dynamic> toJson() => {'Des': des.toJson()};
}
