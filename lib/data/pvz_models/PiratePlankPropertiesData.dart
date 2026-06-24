import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PiratePlankPropertiesData extends PvzModel {
  PiratePlankPropertiesData({this.plankRows = const []});

  List<int> plankRows;

  factory PiratePlankPropertiesData.fromJson(Map<String, dynamic> json) {
    return PiratePlankPropertiesData(
      plankRows: (json['PlankRows'] as List<dynamic>?)?.cast<int>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {'PlankRows': plankRows};
}
