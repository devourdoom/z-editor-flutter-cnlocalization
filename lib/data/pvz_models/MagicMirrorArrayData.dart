import 'package:c_editor/data/pvz_models/PvzModel.dart';

class MagicMirrorArrayData extends PvzModel {
  MagicMirrorArrayData({
    this.mirror1GridX = 2,
    this.mirror1GridY = 2,
    this.mirror2GridX = 6,
    this.mirror2GridY = 2,
    this.typeIndex,
    this.mirrorExistDuration = 300,
  });

  int mirror1GridX;
  int mirror1GridY;
  int mirror2GridX;
  int mirror2GridY;

  /// null means "no style" - TypeIndex is omitted in JSON
  int? typeIndex;
  int mirrorExistDuration;

  factory MagicMirrorArrayData.fromJson(Map<String, dynamic> json) {
    return MagicMirrorArrayData(
      mirror1GridX: json['Mirror1GridX'] as int? ?? 2,
      mirror1GridY: json['Mirror1GridY'] as int? ?? 2,
      mirror2GridX: json['Mirror2GridX'] as int? ?? 6,
      mirror2GridY: json['Mirror2GridY'] as int? ?? 2,
      typeIndex: json['TypeIndex'] as int?,
      mirrorExistDuration: json['MirrorExistDuration'] as int? ?? 300,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'Mirror1GridX': mirror1GridX,
      'Mirror1GridY': mirror1GridY,
      'Mirror2GridX': mirror2GridX,
      'Mirror2GridY': mirror2GridY,
      'MirrorExistDuration': mirrorExistDuration,
    };
    if (typeIndex != null) {
      map['TypeIndex'] = typeIndex;
    }
    return map;
  }
}
