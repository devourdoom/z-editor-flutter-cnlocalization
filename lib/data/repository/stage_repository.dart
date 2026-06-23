import 'package:flutter/widgets.dart';
import 'package:c_editor/data/repository/stage_catalog_repository.dart';

/// Stage data for level editor selection UI.
enum StageType { all, main, extra, seasons, special }

class StageItem {
  const StageItem({required this.alias, this.iconName, required this.type});

  final String alias;
  final String? iconName;
  final StageType type;
}

class StageRepository {
  StageRepository._();

  static final List<StageItem> _database = [];
  static bool _isLoaded = false;

  static Future<void> init() async {
    if (_isLoaded) return;
    try {
      await StageCatalogRepository.init();
      _database
        ..clear()
        ..addAll(_buildItemsFromCatalog());
      _isLoaded = true;
    } catch (e) {
      debugPrint('Error loading stages: $e');
    }
  }

  static List<StageItem> _buildItemsFromCatalog() {
    final out = <StageItem>[];
    final seen = <String>{};
    for (final section in StageCatalogRepository.sections) {
      for (final impl in section.implementations) {
        if (impl.tag == null || !seen.add(impl.alias)) continue;
        out.add(
          StageItem(
            alias: impl.alias,
            iconName: impl.image,
            type: _parseType(impl.tag),
          ),
        );
      }
    }
    out.sort((a, b) => a.alias.compareTo(b.alias));
    return out;
  }

  static List<StageItem> get allItems => List.unmodifiable(_database);

  static List<StageItem> getByType(StageType type) {
    if (type == StageType.all) return allItems;
    return _database.where((s) => s.type == type).toList();
  }

  /// Localization key for stage name. Use ResourceNames.lookup(context, getName(alias)).
  static String getName(String alias) => 'stage_$alias';

  static StageType _parseType(String? raw) {
    return StageType.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => StageType.main,
    );
  }
}
