import 'package:c_editor/data/pvz_models/PvzModel.dart';

enum BronzeStatueKind { strength, mage, agile }

class BronzeStatueItemData extends PvzModel {
  BronzeStatueItemData({
    this.mX = 0,
    this.mY = 0,
    this.spawnTime = 60,
    this.kind = BronzeStatueKind.strength,
  });

  /// Column (grid X).
  int mX;

  /// Row (grid Y).
  int mY;

  /// Countdown until this bronze revives (seconds in level data).
  int spawnTime;
  BronzeStatueKind kind;

  factory BronzeStatueItemData.fromJson(Map<String, dynamic> json) {
    return BronzeStatueItemData(
      mX: (json['mX'] as num?)?.toInt() ?? 0,
      mY: (json['mY'] as num?)?.toInt() ?? 0,
      spawnTime: (json['spawnTime'] as num?)?.toInt() ?? 60,
      kind: _parseBronzeKind(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
    'mX': mX,
    'mY': mY,
    'spawnTime': spawnTime,
    'type': _bronzeKindToGameString(kind),
  };
}

BronzeStatueKind _parseBronzeKind(dynamic raw) {
  final t = raw?.toString().toLowerCase() ?? 'strength';
  if (t == 'strength' || t == 'strong') return BronzeStatueKind.strength;
  if (t == 'mage' || t == 'magic') return BronzeStatueKind.mage;
  if (t == 'agile') return BronzeStatueKind.agile;
  return BronzeStatueKind.strength;
}

String _bronzeKindToGameString(BronzeStatueKind k) {
  return switch (k) {
    BronzeStatueKind.strength => 'strength',
    BronzeStatueKind.mage => 'mage',
    BronzeStatueKind.agile => 'agile',
  };
}
