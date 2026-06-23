import 'package:flutter/material.dart';
import 'package:c_editor/data/custom_stage_level_utils.dart';
import 'package:c_editor/data/repository/stage_catalog_repository.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/l10n/resource_names.dart';
import 'package:c_editor/utils/selection_search.dart';
import 'package:c_editor/widgets/asset_image.dart'
    show AssetImageWidget, imageAltCandidates;
import 'package:c_editor/widgets/editor_components.dart';

/// Pick a base stage properties objclass when creating a custom lawn.
class StageObjclassSelectionScreen extends StatefulWidget {
  const StageObjclassSelectionScreen({
    super.key,
    required this.onObjclassSelected,
    required this.onBack,
  });

  final void Function(String objclass) onObjclassSelected;
  final VoidCallback onBack;

  @override
  State<StageObjclassSelectionScreen> createState() =>
      _StageObjclassSelectionScreenState();
}

class _StageObjclassSelectionScreenState
    extends State<StageObjclassSelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    var items = StageCatalogRepository.objclassIcons.entries
        .where(
          (e) => !CustomStageLevelUtils.excludedCustomStageObjclasses
              .contains(e.key),
        )
        .toList()
      ..sort((a, b) {
        final nameA = ResourceNames.lookup(
          context,
          StageCatalogRepository.objclassResourceKey(a.key),
        );
        final nameB = ResourceNames.lookup(
          context,
          StageCatalogRepository.objclassResourceKey(b.key),
        );
        return nameA.compareTo(nameB);
      });
    if (normalizeSelectionSearchQuery(_searchQuery).isNotEmpty) {
      items = items.where((entry) {
        final resourceKey =
            StageCatalogRepository.objclassResourceKey(entry.key);
        final name = ResourceNames.lookup(context, resourceKey);
        return matchesSelectionSearch(_searchQuery, [
          entry.key,
          resourceKey,
          name,
        ]);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(l10n?.selectCustomStageBase ?? 'Select base lawn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SelectionSearchField(
              hintText: l10n?.searchStageObjclass ?? 'Search lawn type',
              query: _searchQuery,
              onChanged: (v) => setState(() => _searchQuery = v),
              onClear: () => setState(() => _searchQuery = ''),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      l10n?.noStageObjclassFound ?? 'No lawn type found',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final entry = items[i];
                      final resourceKey =
                          StageCatalogRepository.objclassResourceKey(entry.key);
                      final displayName =
                          ResourceNames.lookup(context, resourceKey);
                      final iconPath =
                          'assets/images/round_icons/${entry.value}';
                      return Card(
                        child: InkWell(
                          onTap: () => widget.onObjclassSelected(entry.key),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: AssetImageWidget(
                                      assetPath: iconPath,
                                      altCandidates:
                                          imageAltCandidates(iconPath),
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  displayName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  entry.key,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
