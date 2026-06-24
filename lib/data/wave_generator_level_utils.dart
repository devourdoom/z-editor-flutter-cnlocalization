import 'package:collection/collection.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';

/// Helpers for reading and writing [WaveGeneratorPropertiesData] in a level file.
class WaveGeneratorLevelUtils {
  WaveGeneratorLevelUtils._();

  static PvzObject? findObject(PvzLevelFile levelFile) {
    return levelFile.objects.firstWhereOrNull(
      (o) => o.objClass == 'WaveGeneratorProperties',
    );
  }

  static WaveGeneratorPropertiesData? readData(PvzLevelFile levelFile) {
    final obj = findObject(levelFile);
    if (obj?.objData is! Map<String, dynamic>) return null;
    try {
      return WaveGeneratorPropertiesData.fromJson(
        Map<String, dynamic>.from(obj!.objData as Map),
      );
    } catch (_) {
      return null;
    }
  }

  static void writeData(
    PvzLevelFile levelFile,
    WaveGeneratorPropertiesData data,
  ) {
    final obj = findObject(levelFile);
    if (obj == null) return;
    data.syncWaveCount();
    obj.objData = data.toJson();
  }

  static PvzObject loadOrCreate(PvzLevelFile levelFile, String rtid) {
    final info = RtidParser.parse(rtid);
    final alias = info?.alias ?? 'WaveGenerator';
    var obj = levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (obj != null) return obj;
    obj = levelFile.objects.firstWhereOrNull(
      (o) => o.objClass == 'WaveGeneratorProperties',
    );
    if (obj != null) return obj;
    obj = PvzObject(
      aliases: [alias],
      objClass: 'WaveGeneratorProperties',
      objData: WaveGeneratorPropertiesData(
        waves: [WaveGeneratorWaveData()],
      ).toJson(),
    );
    levelFile.objects.add(obj);
    return obj;
  }

  static WaveGeneratorPropertiesData parseObject(PvzObject obj) {
    try {
      return WaveGeneratorPropertiesData.fromJson(
        Map<String, dynamic>.from(obj.objData as Map),
      );
    } catch (_) {
      return WaveGeneratorPropertiesData(waves: [WaveGeneratorWaveData()]);
    }
  }

  static String? moduleRtid(PvzLevelFile levelFile, ParsedLevelData parsed) {
    final def = parsed.levelDef;
    if (def == null) return null;
    for (final rtid in def.modules) {
      final info = RtidParser.parse(rtid);
      if (info == null || info.source != 'CurrentLevel') continue;
      final obj = parsed.objectMap[info.alias];
      if (obj?.objClass == 'WaveGeneratorProperties') return rtid;
    }
    final obj = findObject(levelFile);
    if (obj?.aliases?.isNotEmpty == true) {
      return RtidParser.build(obj!.aliases!.first, 'CurrentLevel');
    }
    return null;
  }

  static bool levelUsesWaveGenerator(PvzLevelFile levelFile) {
    return levelFile.objects.any(
      (o) => o.objClass == 'WaveGeneratorProperties',
    );
  }
}
