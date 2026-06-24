import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:c_editor/data/asset_loader.dart';

/// Ambient-level audio codenames (`AmbientAudioSuffix`) and resource bundle dependencies.
class AmbientAudioCatalog {
  AmbientAudioCatalog._();

  static const String _resourcePath =
      'assets/resources/AmbientAudioSuffixes.json';

  static final Map<String, List<String>> _groupsByCodename = {};
  static List<String> _orderedCodenames = [];
  static bool _isLoaded = false;

  /// Codenames including `""` default if present first in JSON.
  static List<String> get orderedCodenames =>
      List.unmodifiable(_orderedCodenames);

  static Future<void> init() async {
    if (_isLoaded) return;
    try {
      final raw =
          json.decode(await loadJsonString(_resourcePath))
              as Map<String, dynamic>;
      final list = raw['entries'] as List<dynamic>? ?? [];
      _groupsByCodename.clear();
      _orderedCodenames = [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final codename = (m['codename'] as String?) ?? '';
        final groups =
            (m['resourceGroups'] as List<dynamic>?)
                ?.map((e) => '$e')
                .toList()
                .where((s) => s.isNotEmpty)
                .toList() ??
            <String>[];
        _groupsByCodename[codename] = groups;
        _orderedCodenames.add(codename);
      }
      _isLoaded = true;
    } catch (e) {
      debugPrint('AmbientAudioCatalog: failed to load $e');
      _groupsByCodename.clear();
      _orderedCodenames = [''];
      _isLoaded = true;
    }
  }

  /// Resource groups referenced by `codename` (may be empty).
  static List<String> resourceGroupsFor(String codename) =>
      List.unmodifiable(_groupsByCodename[codename] ?? const []);

  /// Localized/display key pattern used by ResourceNames (`ambientAudio_$codename`).
  static String resourceKey(String codename) =>
      codename.isEmpty ? 'ambientAudio_default' : 'ambientAudio_$codename';
}
