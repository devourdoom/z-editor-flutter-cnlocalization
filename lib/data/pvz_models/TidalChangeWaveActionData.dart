import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/TidalChangeInternalData.dart';

class TidalChangeWaveActionData extends PvzModel {
  TidalChangeWaveActionData({TidalChangeInternalData? tidalChange})
    : tidalChange = tidalChange ?? TidalChangeInternalData();

  TidalChangeInternalData tidalChange;

  factory TidalChangeWaveActionData.fromJson(Map<String, dynamic> json) {
    return TidalChangeWaveActionData(
      tidalChange: TidalChangeInternalData.fromJson(
        json['TidalChange'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {'TidalChange': tidalChange.toJson()};
}
