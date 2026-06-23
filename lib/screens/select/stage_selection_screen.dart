import 'package:flutter/material.dart';
import 'package:c_editor/data/custom_stage_level_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/repository/stage_repository.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/l10n/resource_names.dart';
import 'package:c_editor/utils/selection_search.dart';
import 'package:c_editor/widgets/asset_image.dart'
    show AssetImageWidget, imageAltCandidates;
import 'package:c_editor/widgets/custom_stage_editor_widgets.dart';
import 'package:c_editor/widgets/editor_components.dart';

enum _StagePickerTab { builtin, custom }

/// Full-screen lawn picker: built-in LevelModules stages or level-local custom lawns.
class StageSelectionScreen extends StatefulWidget {
  const StageSelectionScreen({
    super.key,
    required this.currentStageRtid,
    required this.levelFile,
    required this.onStageSelected,
    required this.onBack,
    this.onCreateCustomStage,
    this.onOpenCustomStageEditor,
    this.onDeleteCustomStage,
    this.onSwitchFromCustomToBuiltin,
  });

  final String currentStageRtid;
  final PvzLevelFile levelFile;
  final void Function(String rtid) onStageSelected;
  final VoidCallback onBack;
  final VoidCallback? onCreateCustomStage;
  final void Function(String alias)? onOpenCustomStageEditor;
  final Future<bool> Function(String alias)? onDeleteCustomStage;
  final Future<bool> Function(String customAlias)? onSwitchFromCustomToBuiltin;

  @override
  State<StageSelectionScreen> createState() => _StageSelectionScreenState();
}

class _StageSelectionScreenState extends State<StageSelectionScreen> {
  late _StagePickerTab _tab;
  StageType _selectedType = StageType.all;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final info = RtidParser.parse(widget.currentStageRtid);
    _tab = info?.source == CustomStageLevelUtils.currentLevel
        ? _StagePickerTab.custom
        : _StagePickerTab.builtin;
  }

  bool get _isCustomCurrent =>
      CustomStageLevelUtils.isCustomStageRtid(widget.currentStageRtid);

  String? get _currentAlias => RtidParser.parse(widget.currentStageRtid)?.alias;

  List<PvzObject> get _customStages =>
      CustomStageLevelUtils.customStageObjectsInLevel(widget.levelFile);

  Future<void> _selectBuiltin(String rtid) async {
    if (_isCustomCurrent) {
      final alias = _currentAlias;
      if (alias != null && widget.onSwitchFromCustomToBuiltin != null) {
        final confirmed = await widget.onSwitchFromCustomToBuiltin!(alias);
        if (!confirmed) return;
      }
    }
    widget.onStageSelected(rtid);
  }

  String _customDisplayName(BuildContext context, PvzObject stageObj) {
    final l10n = AppLocalizations.of(context);
    final alias = stageObj.aliases?.firstOrNull ?? '';
    final objdata = stageObj.objData is Map
        ? Map<String, dynamic>.from(stageObj.objData as Map)
        : const <String, dynamic>{};
    final suffix =
        l10n?.customStageNameSuffix ?? CustomStageLevelUtils.displayNameSuffixDefault;
    final nameKey = CustomStageLevelUtils.displayNameKey(
      backgroundImagePrefix: objdata['BackgroundImagePrefix'] as String?,
      objdata: objdata,
    );
    if (nameKey.isNotEmpty) {
      return '${ResourceNames.lookup(context, nameKey)}$suffix';
    }
    return '$alias$suffix';
  }

  String? _customIconFile(PvzObject stageObj) {
    if (stageObj.objData is! Map) return null;
    return CustomStageLevelUtils.displayIconFileName(
      objclass: stageObj.objClass,
      objdata: Map<String, dynamic>.from(stageObj.objData as Map),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(l10n?.selectStage ?? 'Select lawn'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_tab == _StagePickerTab.builtin ? 148 : 72),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SegmentedButton<_StagePickerTab>(
                  segments: [
                    ButtonSegment(
                      value: _StagePickerTab.builtin,
                      label: Text(l10n?.stageSelectionTabBuiltin ?? 'Built-in'),
                      icon: const Icon(Icons.grass),
                    ),
                    ButtonSegment(
                      value: _StagePickerTab.custom,
                      label: Text(l10n?.stageSelectionTabCustom ?? 'Custom'),
                      icon: const Icon(Icons.edit_note),
                    ),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (values) {
                    setState(() => _tab = values.first);
                  },
                ),
              ),
              if (_tab == _StagePickerTab.builtin) ...[
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
                    children: StageType.values.map((t) {
                      return AccentBarChoiceChip(
                        label: _typeLabel(t, l10n),
                        selected: _selectedType == t,
                        onSelected: (_) => setState(() => _selectedType = t),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      body: _tab == _StagePickerTab.builtin
          ? _buildBuiltinTab(context, l10n, theme)
          : _buildCustomTab(context, l10n, theme),
    );
  }

  Widget _buildBuiltinTab(
    BuildContext context,
    AppLocalizations? l10n,
    ThemeData theme,
  ) {
    final currentAlias = _currentAlias ?? '';
    var items = StageRepository.getByType(_selectedType);
    if (normalizeSelectionSearchQuery(_searchQuery).isNotEmpty) {
      items = items.where((s) {
        final nameKey = StageRepository.getName(s.alias);
        return matchesSelectionSearch(_searchQuery, [
          s.alias,
          nameKey,
          ResourceNames.lookup(context, nameKey),
        ]);
      }).toList();
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              l10n?.noStageFound ?? 'No stage found',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final stage = items[i];
        final isSelected =
            !_isCustomCurrent && stage.alias == currentAlias;
        return _BuiltinStageGridItem(
          stage: stage,
          stageName: ResourceNames.lookup(
            context,
            StageRepository.getName(stage.alias),
          ),
          isSelected: isSelected,
          onTap: () => _selectBuiltin(
            RtidParser.build(stage.alias, 'LevelModules'),
          ),
        );
      },
    );
  }

  Widget _buildCustomTab(
    BuildContext context,
    AppLocalizations? l10n,
    ThemeData theme,
  ) {
    final customStages = _customStages;
    final currentAlias = _currentAlias;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.onCreateCustomStage != null && customStages.isEmpty)
          Card(
            color: theme.colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(
                l10n?.createCustomStage ?? 'Create custom lawn',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                l10n?.createCustomStageHint ??
                    'Pick a base stage properties type and edit it locally.',
              ),
              onTap: widget.onCreateCustomStage,
            ),
          ),
        if (customStages.isEmpty) ...[
          const SizedBox(height: 32),
          Center(
            child: Text(
              l10n?.customStageSelectionEmpty ??
                  'No custom lawn in this level yet.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
          Text(
            l10n?.customStageSelectionInLevel ?? 'Custom lawns in this level',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...customStages.map((stageObj) {
            final alias = stageObj.aliases?.firstOrNull ?? '';
            final isSelected =
                _isCustomCurrent && alias == currentAlias;
            final iconFile = _customIconFile(stageObj);
            final iconPath = iconFile == null
                ? 'assets/images/others/unknown.webp'
                : 'assets/images/round_icons/$iconFile';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: isSelected ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected
                      ? BorderSide(color: theme.colorScheme.outline, width: 1)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () => widget.onOpenCustomStageEditor?.call(alias),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: AssetImageWidget(
                                  assetPath: iconPath,
                                  altCandidates: imageAltCandidates(iconPath),
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 2,
                              left: 2,
                              child: CustomStageBadge(),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _customDisplayName(context, stageObj),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                alias,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.onDeleteCustomStage != null)
                          IconButton(
                            tooltip: l10n?.delete ?? 'Delete',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final deleted =
                                  await widget.onDeleteCustomStage!(alias);
                              if (deleted && mounted) setState(() {});
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  String _typeLabel(StageType t, AppLocalizations? l10n) {
    switch (t) {
      case StageType.all:
        return l10n?.stageTypeAll ?? 'All';
      case StageType.main:
        return l10n?.stageTypeMain ?? 'Main';
      case StageType.extra:
        return l10n?.stageTypeExtra ?? 'Extra';
      case StageType.seasons:
        return l10n?.stageTypeSeasons ?? 'Seasons';
      case StageType.special:
        return l10n?.stageTypeSpecial ?? 'Special';
    }
  }
}

class _BuiltinStageGridItem extends StatelessWidget {
  const _BuiltinStageGridItem({
    required this.stage,
    required this.stageName,
    required this.isSelected,
    required this.onTap,
  });

  final StageItem stage;
  final String stageName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isSelected ? theme.colorScheme.primaryContainer : null,
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
                  child: stage.iconName != null
                      ? AssetImageWidget(
                          assetPath:
                              'assets/images/round_icons/${stage.iconName!}',
                          altCandidates: imageAltCandidates(
                            'assets/images/round_icons/${stage.iconName!}',
                          ),
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        )
                      : const AssetImageWidget(
                          assetPath: 'assets/images/others/unknown.webp',
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                stage.alias,
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
