import 'package:flutter/material.dart';
import 'package:c_editor/data/repository/tool_repository.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/utils/selection_search.dart';
import 'package:c_editor/widgets/asset_image.dart' show AssetImageWidget;
import 'package:c_editor/widgets/editor_components.dart';

/// Tool selection. Ported from Z-Editor-master ToolSelectionScreen.kt
class ToolSelectionScreen extends StatefulWidget {
  const ToolSelectionScreen({
    super.key,
    required this.onToolSelected,
    required this.onBack,
  });

  final void Function(String id) onToolSelected;
  final VoidCallback onBack;

  @override
  State<ToolSelectionScreen> createState() => _ToolSelectionScreenState();
}

class _ToolSelectionScreenState extends State<ToolSelectionScreen> {
  String _searchQuery = '';

  List<ToolCardInfo> _filteredTools(BuildContext context) {
    return ToolRepository.getAll().where((tool) {
      return matchesSelectionSearch(_searchQuery, [
        tool.id,
        tool.name,
        ToolRepository.localizedName(context, tool.id),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tools = _filteredTools(context);
    final theme = Theme.of(context);
    final themeColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        title: Text(
          l10n?.selectToolCard ?? 'Select tool card',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SelectionSearchField(
              hintText: l10n?.search ?? 'Search',
              query: _searchQuery,
              fillColor: theme.colorScheme.surface,
              onChanged: (v) => setState(() => _searchQuery = v),
              onClear: () => setState(() => _searchQuery = ''),
            ),
          ),
        ),
      ),
      body: Container(
        color: theme.colorScheme.surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 600;
            final crossAxisCount =
                SelectionGridLayout.toolCrossAxisCount(constraints.maxWidth);
            final iconBox =
                SelectionGridLayout.toolIconBox(constraints.maxWidth);
            return GridView.builder(
              padding: const EdgeInsets.all(SelectionGridLayout.padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: SelectionGridLayout.toolChildAspectRatio(
                  constraints.maxWidth,
                ),
                crossAxisSpacing: SelectionGridLayout.spacing,
                mainAxisSpacing: SelectionGridLayout.spacing,
              ),
              itemCount: tools.length,
              itemBuilder: (context, index) {
                final tool = tools[index];
                final iconPath = tool.icon != null
                    ? 'assets/images/tools/${tool.icon}'
                    : null;
                return _ToolCard(
                  id: tool.id,
                  name: ToolRepository.localizedName(context, tool.id),
                  iconPath: iconPath,
                  iconWidth: iconBox.width,
                  iconHeight: iconBox.height,
                  theme: theme,
                  showToolId: isDesktop,
                  onTap: () => widget.onToolSelected(tool.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.iconWidth,
    required this.iconHeight,
    required this.theme,
    required this.showToolId,
    required this.onTap,
  });

  final String id;
  final String name;
  final String? iconPath;
  final double iconWidth;
  final double iconHeight;
  final ThemeData theme;
  final bool showToolId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ToolIcon(
                iconPath: iconPath,
                width: iconWidth,
                height: iconHeight,
                theme: theme,
              ),
              const SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showToolId) ...[
                const SizedBox(height: 4),
                Text(
                  id,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({
    required this.iconPath,
    required this.width,
    required this.height,
    required this.theme,
  });

  final String? iconPath;
  final double width;
  final double height;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: iconPath != null
          ? AssetImageWidget(assetPath: iconPath!, fit: BoxFit.contain)
          : Icon(
              Icons.build,
              size: height * 0.5,
              color: theme.colorScheme.outline,
            ),
    );
  }
}
