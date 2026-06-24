import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:c_editor/data/models/zomboss_mech_catalog.dart';
import 'package:c_editor/data/pvz_models/PvzLevelFile.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/data/zomboss_mech_action_utils.dart';
import 'package:c_editor/data/zomboss_mech_l10n.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/others/custom_zomboss_mech_action_editor_screen.dart';
import 'package:c_editor/utils/selection_search.dart';
import 'package:c_editor/widgets/animated_extended_fab.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Picks a catalog or level-local zomboss action; returns RTID string.
class ZombossMechActionSelectionScreen extends StatefulWidget {
  const ZombossMechActionSelectionScreen({
    super.key,
    required this.catalog,
    required this.levelFile,
    this.retreatOnly = false,
  });

  final ZombossMechCatalogEntry catalog;
  final PvzLevelFile levelFile;
  final bool retreatOnly;

  @override
  State<ZombossMechActionSelectionScreen> createState() =>
      _ZombossMechActionSelectionScreenState();
}

class _ZombossMechActionSelectionScreenState
    extends State<ZombossMechActionSelectionScreen> {
  static const _categories = ['all', 'movement', 'attack', 'special'];
  String _category = 'all';
  String _query = '';
  final ScrollController _listScrollController = ScrollController();
  bool _listScrollAtTop = true;

  @override
  void initState() {
    super.initState();
    _listScrollController.addListener(_onListScroll);
  }

  @override
  void dispose() {
    _listScrollController.removeListener(_onListScroll);
    _listScrollController.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_listScrollController.hasClients) return;
    final atTop = _listScrollController.offset <= 0;
    if (atTop != _listScrollAtTop && mounted) {
      setState(() => _listScrollAtTop = atTop);
    }
  }

  List<_ActionListItem> get _items {
    final items = <_ActionListItem>[];
    if (widget.retreatOnly) {
      for (final action in widget.catalog.retreatCatalogActions) {
        items.add(
          _ActionListItem.catalog(
            catalog: widget.catalog,
            action: action,
            rtid: RtidParser.build(
              action.alias,
              ZombossMechActionUtils.catalogSource,
            ),
          ),
        );
      }
    } else {
      final tag = _category == 'all' ? null : _category;
      for (final action in widget.catalog.actionsByTag(tag)) {
        items.add(
          _ActionListItem.catalog(
            catalog: widget.catalog,
            action: action,
            rtid: RtidParser.build(
              action.alias,
              ZombossMechActionUtils.catalogSource,
            ),
          ),
        );
      }
    }
    for (final obj in widget.levelFile.objects) {
      final alias = obj.aliases?.firstOrNull;
      if (alias == null) continue;
      final group = widget.catalog.actions
          .where((g) => g.objclass == obj.objClass)
          .firstOrNull;
      if (group == null) continue;
      if (widget.retreatOnly && group.tag != 'retreat') continue;
      if (!widget.retreatOnly && group.tag == 'retreat') continue;
      if (!widget.retreatOnly && _category != 'all' && group.tag != _category) {
        continue;
      }
      items.add(
        _ActionListItem.custom(
          catalog: widget.catalog,
          alias: alias,
          objclass: obj.objClass,
          tag: group.tag,
          rtid: RtidParser.build(alias, ZombossMechActionUtils.customSource),
        ),
      );
    }
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where((e) => matchesSelectionSearch(_query, e.searchTerms(context)))
        .toList();
  }

  String _categoryLabel(BuildContext context, String key) {
    if (key == 'all') {
      return AppLocalizations.of(context)?.zombossMechActionCategoryAll ??
          'All';
    }
    return ZombossMechL10n.tagLabel(context, key);
  }

  Future<void> _openCreateCustom() async {
    final rtid = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomZombossMechActionEditorScreen(
          catalog: widget.catalog,
          levelFile: widget.levelFile,
          retreatOnly: widget.retreatOnly,
        ),
      ),
    );
    if (rtid != null && mounted) Navigator.pop(context, rtid);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.retreatOnly
              ? (l10n?.zombossMechSelectRetreatAction ??
                    'Select retreat action')
              : (l10n?.zombossMechSelectAction ?? 'Select action'),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (!widget.retreatOnly)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      for (final cat in _categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_categoryLabel(context, cat)),
                            selected: _category == cat,
                            onSelected: (_) => setState(() => _category = cat),
                          ),
                        ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SelectionSearchField(
                  hintText: l10n?.search ?? 'Search',
                  query: _query,
                  useOutlineBorder: true,
                  onChanged: (v) => setState(() => _query = v),
                  onClear: () => setState(() => _query = ''),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          l10n?.zombossMechNoActionsFound ?? 'No actions found',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _listScrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item.primaryLabel(context)),
                            subtitle: Text(
                              item.secondaryLabel(context),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: item.isCustom
                                ? IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: l10n?.edit ?? 'Edit',
                                    onPressed: () async {
                                      final rtid = await Navigator.push<String>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomZombossMechActionEditorScreen(
                                                catalog: widget.catalog,
                                                levelFile: widget.levelFile,
                                                existingRtid: item.rtid,
                                                retreatOnly: widget.retreatOnly,
                                              ),
                                        ),
                                      );
                                      if (!context.mounted) return;
                                      if (rtid != null) {
                                        Navigator.pop(context, rtid);
                                      }
                                    },
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, item.rtid),
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: AnimatedExtendedFab(
              visible: _listScrollAtTop,
              heroTag: 'zombossMechCreateCustomAction',
              onPressed: _openCreateCustom,
              icon: Icons.add,
              label: l10n?.zombossMechCreateCustomAction ?? 'New custom action',
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionListItem {
  _ActionListItem.catalog({
    required this.catalog,
    required ZombossMechCatalogAction action,
    required this.rtid,
  }) : isCustom = false,
       catalogAction = action,
       alias = action.alias,
       objclass = action.objclass,
       tag = action.tag;

  _ActionListItem.custom({
    required this.catalog,
    required this.alias,
    required this.objclass,
    required this.tag,
    required this.rtid,
  }) : isCustom = true,
       catalogAction = null;

  final ZombossMechCatalogEntry catalog;
  final ZombossMechCatalogAction? catalogAction;
  final String rtid;
  final bool isCustom;
  final String alias;
  final String objclass;
  final String tag;

  String primaryLabel(BuildContext context) {
    if (isCustom) {
      return ZombossMechL10n.actionLabel(
        context,
        catalog.id,
        objclass,
        fallback: alias,
      );
    }
    return ZombossMechL10n.implementationLabel(context, catalog.id, alias);
  }

  String secondaryLabel(BuildContext context) {
    final info = RtidParser.parse(rtid);
    if (info != null) {
      return '${info.alias}@${info.source}';
    }
    return rtid;
  }

  Iterable<String> searchTerms(BuildContext context) sync* {
    yield primaryLabel(context);
    yield secondaryLabel(context);
    yield alias;
    yield objclass;
    yield tag;
    yield rtid;
    yield ZombossMechL10n.actionKey(catalog.id, objclass);
    yield ZombossMechL10n.actionImplementationKey(catalog.id, alias);
  }
}
