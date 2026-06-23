import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:c_editor/data/asset_loader.dart';
import 'package:c_editor/data/models/stage_catalog.dart';

/// Loads `Stages.json`, `Stages_helper.json`, and `Stages_objclass_helper.json`.
abstract final class StageCatalogRepository {
  static const _catalogPath = 'assets/resources/Stages.json';
  static const _helperPath = 'assets/resources/Stages_helper.json';
  static const _objclassHelperPath = 'assets/resources/Stages_objclass_helper.json';

  static final List<StageCatalogSection> _sections = [];
  static final Map<String, StageCatalogSection> _byObjclass = {};
  static final Map<String, String> _objclassIcons = {};
  static final Map<String, dynamic> _helperTree = {};
  static final Set<String> _knownResourceGroups = {};
  static bool _isLoaded = false;

  static List<StageCatalogSection> get sections => List.unmodifiable(_sections);

  static Map<String, String> get objclassIcons =>
      Map.unmodifiable(_objclassIcons);

  static String objclassResourceKey(String objclass) =>
      'stageObjclass_$objclass';

  static Set<String> get knownResourceGroups =>
      Set.unmodifiable(_knownResourceGroups);

  @visibleForTesting
  static void resetForTest() {
    _isLoaded = false;
    _sections.clear();
    _byObjclass.clear();
    _objclassIcons.clear();
    _helperTree.clear();
    _knownResourceGroups.clear();
  }

  static Future<void> init() async {
    if (_isLoaded) return;
    final catalogRaw = json.decode(await loadJsonString(_catalogPath));
    final helperRaw = json.decode(await loadJsonString(_helperPath));
    final objclassRaw = json.decode(await loadJsonString(_objclassHelperPath));

    if (catalogRaw is! List<dynamic>) {
      throw FormatException('Expected array in $_catalogPath');
    }
    if (helperRaw is! Map<String, dynamic>) {
      throw FormatException('Expected object in $_helperPath');
    }
    if (objclassRaw is! Map<String, dynamic>) {
      throw FormatException('Expected object in $_objclassHelperPath');
    }

    _sections
      ..clear()
      ..addAll(
        catalogRaw.map(
          (e) => StageCatalogSection.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        ),
      );
    _byObjclass
      ..clear()
      ..addEntries(_sections.map((s) => MapEntry(s.objclass, s)));
    _objclassIcons
      ..clear()
      ..addAll(
        objclassRaw.map((k, v) {
          if (v is String) return MapEntry(k, v);
          if (v is Map && v['image'] is String) {
            return MapEntry(k, v['image'] as String);
          }
          return MapEntry(k, 'unknown.webp');
        }),
      );
    _helperTree
      ..clear()
      ..addAll(helperRaw);
    _knownResourceGroups.clear();
    for (final section in _sections) {
      for (final impl in section.implementations) {
        _collectGroups(impl.objdata['ResourceGroupNames']);
        _collectGroups(impl.objdata['GroupsToUnloadForAds']);
      }
    }
    _isLoaded = true;
  }

  static void _collectGroups(dynamic raw) {
    if (raw is! List) return;
    for (final item in raw) {
      if (item is String && item.isNotEmpty) {
        _knownResourceGroups.add(item);
      }
    }
  }

  static StageCatalogSection? sectionForObjclass(String objclass) =>
      _byObjclass[objclass];

  static StageImplementation? catalogImplementation(String alias) {
    for (final section in _sections) {
      final impl = section.implementationFor(alias);
      if (impl != null) return impl;
    }
    return null;
  }

  static List<StageImplementation> catalogStagesWithIcon() {
    final out = <StageImplementation>[];
    for (final section in _sections) {
      for (final impl in section.implementations) {
        if (impl.image != null && impl.image!.isNotEmpty) {
          out.add(impl);
        }
      }
    }
    out.sort((a, b) => a.alias.compareTo(b.alias));
    return out;
  }

  static String resourceGroupKey(String codename) => 'resourceGroup_$codename';

  static List<String> delayLoadGroupsInLists(
    List<String> resourceGroupNames,
    List<String> groupsToUnloadForAds,
  ) {
    final out = <String>{};
    for (final group in [...resourceGroupNames, ...groupsToUnloadForAds]) {
      if (group.startsWith('DelayLoad_Background')) {
        out.add(group);
      }
    }
    return out.toList()..sort();
  }

  static bool hasKnownDelayLoadBackground(
    List<String> resourceGroupNames,
    List<String> groupsToUnloadForAds,
  ) {
    final delayLoads = delayLoadGroupsInLists(
      resourceGroupNames,
      groupsToUnloadForAds,
    );
    for (final group in delayLoads) {
      if (_helperTree.containsKey(group)) return true;
    }
    return false;
  }

  static List<StageBackgroundOption> backgroundOptionsForDelayLoads(
    Iterable<String> delayLoadGroups,
  ) {
    final out = <StageBackgroundOption>[];
    for (final delayLoad in delayLoadGroups) {
      final entry = _helperTree[delayLoad];
      if (entry is! Map) continue;
      if (entry.containsKey('image')) {
        out.add(
          StageBackgroundOption(
            delayLoadGroup: delayLoad,
            imagePrefix: '',
            image: entry['image'] as String? ?? 'unknown.webp',
            nameKey: entry['nameKey'] as String? ?? '',
          ),
        );
        continue;
      }
      for (final prefixEntry in entry.entries) {
        if (prefixEntry.value is! Map) continue;
        final leaf = Map<String, dynamic>.from(prefixEntry.value as Map);
        out.add(
          StageBackgroundOption(
            delayLoadGroup: delayLoad,
            imagePrefix: prefixEntry.key,
            image: leaf['image'] as String? ?? 'unknown.webp',
            nameKey: leaf['nameKey'] as String? ?? '',
          ),
        );
      }
    }
    out.sort((a, b) {
      final name = a.nameKey.compareTo(b.nameKey);
      if (name != 0) return name;
      return a.imagePrefix.compareTo(b.imagePrefix);
    });
    return out;
  }

  static StageBackgroundOption? resolveBackgroundDisplay({
    required String? backgroundImagePrefix,
    required String? backgroundResourceGroup,
    List<String> resourceGroupNames = const [],
    List<String> groupsToUnloadForAds = const [],
  }) {
    final delayLoads = delayLoadGroupsInLists(
      resourceGroupNames,
      groupsToUnloadForAds,
    );
    if (backgroundResourceGroup != null &&
        delayLoads.contains(backgroundResourceGroup)) {
      delayLoads
        ..clear()
        ..add(backgroundResourceGroup);
    }
    final options = backgroundOptionsForDelayLoads(
      delayLoads.isEmpty && backgroundResourceGroup != null
          ? [backgroundResourceGroup]
          : delayLoads,
    );
    if (backgroundImagePrefix != null && backgroundImagePrefix.isNotEmpty) {
      final match = options.firstWhereOrNull(
        (o) => o.imagePrefix == backgroundImagePrefix,
      );
      if (match != null) return match;
    }
    return options.isNotEmpty ? options.first : null;
  }

  static List<Map<String, dynamic>> defaultDisabledStreetCells(
    String objclass,
  ) {
    const special = {
      'AtlantisStageProperties',
      'DeepseaStageProperties',
      'DeepseaStageLandProperties',
    };
    final targetObjclass = special.contains(objclass)
        ? objclass
        : 'EgyptStageProperties';
    final section = _byObjclass[targetObjclass];
    final field = section?.fields.firstWhereOrNull(
      (f) => f.name == 'DisabledStreetCells',
    );
    final raw = field?.defaultValue;
    if (raw is List) {
      return raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(growable: false);
    }
    return const [];
  }

  static Map<String, dynamic> templateObjdataForObjclass(String objclass) {
    final section = _byObjclass[objclass];
    final impl = section?.primaryImplementation;
    if (impl != null) {
      return Map<String, dynamic>.from(impl.objdata);
    }
    final data = <String, dynamic>{};
    for (final field in section?.fields ?? const <StageFieldSpec>[]) {
      if (field.defaultValue != null) {
        data[field.name] = _cloneJson(field.defaultValue);
      }
    }
    return data;
  }

  static dynamic _cloneJson(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), _cloneJson(val)),
      );
    }
    if (value is List) {
      return value.map(_cloneJson).toList();
    }
    return value;
  }
}
