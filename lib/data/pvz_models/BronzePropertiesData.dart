import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/BronzeStatueBatchData.dart';

class BronzePropertiesData extends PvzModel {
  BronzePropertiesData({
    List<BronzeStatueBatchData>? data,
    this.shakeOffset = 0.6,
  }) : data = data ?? [];

  List<BronzeStatueBatchData> data;
  double shakeOffset;

  factory BronzePropertiesData.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>?;
    return BronzePropertiesData(
      data:
          list
              ?.map(
                (e) =>
                    BronzeStatueBatchData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      shakeOffset: (json['shakeOffset'] as num?)?.toDouble() ?? 0.6,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'shakeOffset': shakeOffset,
  };
}
