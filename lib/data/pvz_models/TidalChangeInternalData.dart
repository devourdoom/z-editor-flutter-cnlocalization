import 'package:c_editor/data/pvz_models/PvzModel.dart';

class TidalChangeInternalData extends PvzModel {
  TidalChangeInternalData({
    this.changeAmount = 0,
    this.changeType = 'absolute',
  });

  int changeAmount;
  String changeType;

  factory TidalChangeInternalData.fromJson(Map<String, dynamic> json) {
    return TidalChangeInternalData(
      changeAmount: json['ChangeAmount'] as int? ?? 0,
      changeType: json['ChangeType'] as String? ?? 'absolute',
    );
  }

  Map<String, dynamic> toJson() => {
    'ChangeAmount': changeAmount,
    'ChangeType': changeType,
  };
}
