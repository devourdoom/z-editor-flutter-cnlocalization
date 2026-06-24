import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ThunderEntryData extends PvzModel {
  ThunderEntryData({this.type = 'positive'});

  /// positive | negative
  String type;

  factory ThunderEntryData.fromJson(Map<String, dynamic> json) {
    return ThunderEntryData(type: json['Type'] as String? ?? 'positive');
  }

  Map<String, dynamic> toJson() => {'Type': type};
}
