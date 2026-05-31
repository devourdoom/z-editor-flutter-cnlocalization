import 'package:flutter/material.dart';
import 'package:z_editor/data/repository/rift_theme_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/l10n/resource_names.dart';

/// Multi-select picker for rift themes. Tap to toggle; confirm with the check button.
class RiftThemeSelectionScreen extends StatefulWidget {
  const RiftThemeSelectionScreen({
    super.key,
    required this.initialSelectedIds,
    required this.accentColor,
    required this.onThemesConfirmed,
    required this.onBack,
  });

  final List<String> initialSelectedIds;
  final Color accentColor;
  final void Function(List<String> ids) onThemesConfirmed;
  final VoidCallback onBack;

  @override
  State<RiftThemeSelectionScreen> createState() =>
      _RiftThemeSelectionScreenState();
}

class _RiftThemeSelectionScreenState extends State<RiftThemeSelectionScreen> {
  String _searchQuery = '';
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List<String>.from(widget.initialSelectedIds);
  }

  List<String> get _filteredThemes {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return RiftThemeRepository.themeIds;
    return RiftThemeRepository.themeIds.where((id) {
      final nameKey = RiftThemeRepository.nameKey(id);
      final name = ResourceNames.lookup(context, nameKey).toLowerCase();
      return id.toLowerCase().contains(query) || name.contains(query);
    }).toList();
  }

  String _themeLabel(String id) {
    final nameKey = RiftThemeRepository.nameKey(id);
    final name = ResourceNames.lookup(context, nameKey);
    if (name != nameKey) {
      return name;
    }
    return id;
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final themes = _filteredThemes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.accentColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n?.back ?? 'Back',
          onPressed: widget.onBack,
        ),
        title: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: l10n?.selectedCountTapToSearch(_selectedIds.length) ??
                'Selected ${_selectedIds.length}, tap to search',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.onThemesConfirmed(List<String>.from(_selectedIds)),
        backgroundColor: widget.accentColor,
        foregroundColor: Colors.white,
        tooltip: l10n?.confirm ?? 'Confirm',
        child: const Icon(Icons.check),
      ),
      body: themes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n?.riftThemeNoSearchResults ?? 'No matching themes',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final id = themes[index];
                final isSelected = _selectedIds.contains(id);
                final displayName = _themeLabel(id);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isSelected
                      ? widget.accentColor.withValues(alpha: 0.08)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? widget.accentColor
                          : theme.dividerColor.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _toggle(id),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: widget.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: widget.accentColor.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Icon(
                              Icons.palette_outlined,
                              color: widget.accentColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  id,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: isSelected,
                            activeColor: widget.accentColor,
                            onChanged: (_) => _toggle(id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
