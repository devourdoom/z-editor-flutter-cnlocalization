import 'package:flutter/material.dart';
import 'package:c_editor/data/models/stage_catalog.dart';
import 'package:c_editor/data/repository/stage_catalog_repository.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/l10n/resource_names.dart';
import 'package:c_editor/utils/selection_search.dart';
import 'package:c_editor/widgets/asset_image.dart'
    show AssetImageWidget, imageAltCandidates;
import 'package:c_editor/widgets/editor_components.dart';

/// Pick the source stage implementation for a level-local custom lawn.
class StageBaseSelectionScreen extends StatefulWidget {
  const StageBaseSelectionScreen({
    super.key,
    required this.onStageBaseSelected,
    required this.onBack,
  });

  final void Function(StageBaseOption option) onStageBaseSelected;
  final VoidCallback onBack;

  @override
  State<StageBaseSelectionScreen> createState() =>
      _StageBaseSelectionScreenState();
}

class _StageBaseSelectionScreenState extends State<StageBaseSelectionScreen> {
  static const _typeTabs = ['all', 'main', 'extra', 'seasons', 'special'];

  String _searchQuery = '';
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    var items = StageCatalogRepository.stageBaseOptions();

    if (_selectedType != 'all') {
      items = items.where((option) => _optionTypeName(option) == _selectedType).toList();
    }

    if (normalizeSelectionSearchQuery(_searchQuery).isNotEmpty) {
      items = items.where((option) {
        final nameKey = _stageNameKey(option.alias);
        final name = ResourceNames.lookup(context, nameKey);
        return matchesSelectionSearch(_searchQuery, [
          name,
          nameKey,
          option.alias,
          option.objclass,
          option.backgroundImagePrefix ?? '',
          option.backgroundResourceGroup ?? '',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SelectionSearchField(
                  hintText: l10n?.searchStage ?? 'Search stage',
                  query: _searchQuery,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  onClear: () => setState(() => _searchQuery = ''),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: _typeTabs.map((type) {
                    return AccentBarChoiceChip(
                      label: _typeLabel(type, l10n),
                      selected: _selectedType == type,
                      onSelected: (_) => setState(() => _selectedType = type),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No lawn found',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final option = items[i];
                return _StageBaseGridItem(
                  option: option,
                  stageName: ResourceNames.lookup(
                    context,
                    _stageNameKey(option.alias),
                  ),
                  onTap: () => widget.onStageBaseSelected(option),
                );
              },
            ),
    );
  }

  String _optionTypeName(StageBaseOption option) {
    final raw = option.type.toString();
    final dot = raw.lastIndexOf('.');
    return dot < 0 ? raw : raw.substring(dot + 1);
  }

  String _typeLabel(String type, AppLocalizations? l10n) {
    switch (type) {
      case 'all':
        return l10n?.stageTypeAll ?? 'All';
      case 'main':
        return l10n?.stageTypeMain ?? 'Main';
      case 'extra':
        return l10n?.stageTypeExtra ?? 'Extra';
      case 'seasons':
        return l10n?.stageTypeSeasons ?? 'Seasons';
      case 'special':
        return l10n?.stageTypeSpecial ?? 'Special';
    }
    return type;
  }

  String _stageNameKey(String alias) => 'stage_$alias';
}

class _StageBaseGridItem extends StatelessWidget {
  const _StageBaseGridItem({
    required this.option,
    required this.stageName,
    required this.onTap,
  });

  final StageBaseOption option;
  final String stageName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconPath = 'assets/images/round_icons/${option.iconName}';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: AssetImageWidget(
                    assetPath: iconPath,
                    altCandidates: imageAltCandidates(iconPath),
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stageName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                option.alias,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
