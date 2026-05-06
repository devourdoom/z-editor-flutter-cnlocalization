import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/music_suffix_catalog.dart';
import 'package:z_editor/data/repository/stage_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/l10n/resource_names.dart';
import 'package:z_editor/widgets/asset_image.dart' show AssetImageWidget, imageAltCandidates;

/// Picker for `MusicSuffix` (codename + icon + localized title).
class MusicSuffixSelectionScreen extends StatefulWidget {
  const MusicSuffixSelectionScreen({
    super.key,
    required this.currentCodename,
    required this.onCodenameSelected,
    required this.onBack,
  });

  final String currentCodename;
  final void Function(String codename) onCodenameSelected;
  final VoidCallback onBack;

  @override
  State<MusicSuffixSelectionScreen> createState() =>
      _MusicSuffixSelectionScreenState();
}

class _MusicSuffixSelectionScreenState extends State<MusicSuffixSelectionScreen> {
  String _searchQuery = '';

  static const double _iconLogicalSize = 52;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final allCodes = <String>['', ...MusicSuffixCatalog.orderedCodes];
    var items = allCodes;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = allCodes.where((code) {
        final name = ResourceNames.lookup(context, MusicSuffixCatalog.resourceKey(code));
        return name.toLowerCase().contains(q) || code.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        title: Text(l10n?.selectMusicSuffix ?? 'Select music suffix'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: l10n?.searchMusicSuffix ?? 'Search name or codename',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
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
                    l10n?.noMusicSuffixFound ?? 'No music suffix found',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.88,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final code = items[i];
                final isSelected = code == widget.currentCodename;
                return _MusicSuffixTile(
                  codename: code,
                  displayName: ResourceNames.lookup(context, MusicSuffixCatalog.resourceKey(code)),
                  iconSize: _iconLogicalSize,
                  isSelected: isSelected,
                  onTap: () => widget.onCodenameSelected(code),
                );
              },
            ),
    );
  }
}

class _MusicSuffixTile extends StatelessWidget {
  const _MusicSuffixTile({
    required this.codename,
    required this.displayName,
    required this.iconSize,
    required this.isSelected,
    required this.onTap,
  });

  final String codename;
  final String displayName;
  final double iconSize;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String assetPath;
    if (codename.isEmpty) {
      assetPath = MusicSuffixCatalog.unknownIconAsset;
    } else {
      final alias = MusicSuffixCatalog.stageAliasForIcon(codename);
      final iconName = alias == null
          ? null
          : StageRepository.allItems
              .firstWhereOrNull((s) => s.alias == alias)
              ?.iconName;
      assetPath = iconName != null
          ? 'assets/images/stages/$iconName'
          : MusicSuffixCatalog.unknownIconAsset;
    }

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
                  width: iconSize,
                  height: iconSize,
                  child: assetPath == MusicSuffixCatalog.unknownIconAsset
                      ? AssetImageWidget(
                          assetPath: assetPath,
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover,
                        )
                      : AssetImageWidget(
                          assetPath: assetPath,
                          altCandidates: imageAltCandidates(assetPath),
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                displayName,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (codename.isNotEmpty)
                Text(
                  codename,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  '—',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
