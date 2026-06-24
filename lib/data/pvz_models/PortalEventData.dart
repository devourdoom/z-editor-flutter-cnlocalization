import 'package:c_editor/data/pvz_models/PvzModel.dart';

class PortalEventData extends PvzModel {
  PortalEventData({
    this.portalType = 'egypt',
    this.portalColumn = 5,
    this.portalRow = 3,
    this.spawnEffect = '',
    this.spawnSoundID = '',
    this.ignoreGraveStone = false,
  });

  String portalType;
  int portalColumn;
  int portalRow;
  String spawnEffect;
  String spawnSoundID;
  bool ignoreGraveStone;

  factory PortalEventData.fromJson(Map<String, dynamic> json) {
    return PortalEventData(
      portalType: json['PortalType'] as String? ?? 'egypt',
      portalColumn: json['PortalColumn'] as int? ?? 5,
      portalRow: json['PortalRow'] as int? ?? 3,
      spawnEffect: json['SpawnEffect'] as String? ?? '',
      spawnSoundID: json['SpawnSoundID'] as String? ?? '',
      ignoreGraveStone: json['IgnoreGraveStone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'PortalType': portalType,
    'PortalColumn': portalColumn,
    'PortalRow': portalRow,
    'SpawnEffect': spawnEffect,
    'SpawnSoundID': spawnSoundID,
    'IgnoreGraveStone': ignoreGraveStone,
  };
}
