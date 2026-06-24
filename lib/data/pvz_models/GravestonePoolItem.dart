import 'package:c_editor/data/pvz_models/PvzModel.dart';

class GravestonePoolItem extends PvzModel {
  GravestonePoolItem({this.count = 1, this.type = ''});

  int count;
  String type;

  factory GravestonePoolItem.fromJson(Map<String, dynamic> json) {
    return GravestonePoolItem(
      count: json['Count'] as int? ?? 1,
      type: json['Type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'Count': count, 'Type': type};
}

/// Barrel types: barrelempty, barrelmoster (zombie), barrelexplosive
