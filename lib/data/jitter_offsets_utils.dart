import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';

/// Helpers for the independent `ZombieJitterOffsets` presets referenced by
/// wave events.
abstract final class JitterOffsetsUtils {
  static const objectClass = 'ZombieJitterOffsets';

  static ZombieJitterOffsetsData dataOf(PvzObject preset) {
    final data = preset.objData;
    if (data is ZombieJitterOffsetsData) return data;
    if (data is Map) {
      return ZombieJitterOffsetsData.fromJson(Map<String, dynamic>.from(data));
    }
    return ZombieJitterOffsetsData();
  }

  /// Unsafe values rejected by the editor:
  /// * a negative increment may prevent the level from settling normally;
  /// * zero random jitter causes referenced zombies to be killed immediately
  ///   before they can appear normally;
  /// * negative random jitter may prevent the level from settling normally.
  static bool isDataValid(ZombieJitterOffsetsData data) =>
      data.offsetIncrement >= 0 && data.randomJitter > 0;

  static bool isPresetValid(PvzObject preset) => isDataValid(dataOf(preset));

  static List<PvzObject> listPresets(PvzLevelFile levelFile) => levelFile
      .objects
      .where((object) => object.objClass == objectClass)
      .toList();

  static List<PvzObject> findReferrers(PvzLevelFile levelFile, String alias) {
    return levelFile.objects.where((object) {
      if (object.objData is! Map) return false;
      final data = Map<String, dynamic>.from(object.objData as Map);
      final rtid = data['JitterOffsets'];
      if (rtid is! String) return false;
      return RtidParser.parse(rtid)?.alias == alias;
    }).toList();
  }

  static int unreferencedCount(PvzLevelFile levelFile) =>
      listPresets(levelFile).where((preset) {
        final aliases = preset.aliases;
        final alias = aliases == null || aliases.isEmpty ? '' : aliases.first;
        return alias.isEmpty || findReferrers(levelFile, alias).isEmpty;
      }).length;

  static String nextAlias(PvzLevelFile levelFile) {
    final taken = levelFile.objects
        .expand((object) => object.aliases ?? const <String>[])
        .toSet();
    var index = 0;
    while (true) {
      final candidate = index == 0 ? 'Offsets' : 'Offsets$index';
      if (!taken.contains(candidate)) return candidate;
      index++;
    }
  }

  static int renamePresetReferences(
    PvzLevelFile levelFile,
    String oldAlias,
    String newAlias,
  ) {
    var changed = 0;
    for (final referrer in findReferrers(levelFile, oldAlias)) {
      final data = Map<String, dynamic>.from(referrer.objData as Map);
      final info = RtidParser.parse(data['JitterOffsets'] as String);
      data['JitterOffsets'] = RtidParser.build(
        newAlias,
        info?.source ?? 'CurrentLevel',
      );
      referrer.objData = data;
      changed++;
    }
    return changed;
  }
}
