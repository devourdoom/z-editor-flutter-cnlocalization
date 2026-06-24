import 'dart:convert';

import 'package:c_editor/data/asset_loader.dart';

/// App metadata loaded from [assetPath] (editable without recompiling).
class AppProperties {
  AppProperties({required this.supportedGameVersion});

  static const assetPath = 'assets/meta/properties.json';

  final String supportedGameVersion;

  static AppProperties? _cached;

  static Future<AppProperties> load() async {
    if (_cached != null) return _cached!;
    final raw =
        json.decode(await loadJsonString(assetPath)) as Map<String, dynamic>;
    _cached = AppProperties(
      supportedGameVersion: raw['supported_game_version'] as String? ?? '0.0.0',
    );
    return _cached!;
  }
}
