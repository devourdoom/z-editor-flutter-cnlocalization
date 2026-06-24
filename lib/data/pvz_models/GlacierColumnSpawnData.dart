import 'package:c_editor/data/pvz_models/GlacierSpawnEntryData.dart';
import 'package:c_editor/data/pvz_models/PvzModel.dart';

/// Spawn weights for one board column (`ZombieSpawnData` item).
class GlacierColumnSpawnData extends PvzModel {
  GlacierColumnSpawnData({List<GlacierSpawnEntryData>? entries})
    : entries = entries ?? [];

  List<GlacierSpawnEntryData> entries;

  factory GlacierColumnSpawnData.fromJson(Map<String, dynamic> json) {
    final raw = json['Entries'];
    final list = <GlacierSpawnEntryData>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) {
          list.add(GlacierSpawnEntryData.fromJson(e));
        } else if (e is Map) {
          list.add(
            GlacierSpawnEntryData.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }
    return GlacierColumnSpawnData(entries: list);
  }

  Map<String, dynamic> toJson() => {
    'Entries': entries.map((e) => e.toJson()).toList(),
  };
}
