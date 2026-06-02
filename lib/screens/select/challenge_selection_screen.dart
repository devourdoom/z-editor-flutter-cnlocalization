import 'package:flutter/material.dart';
import 'package:z_editor/data/repository/challenge_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/theme/app_theme.dart';

/// Challenge selection. Ported from Z-Editor-master ChallengeSelectionScreen.kt
/// Uses PvzOrange colors in both light and dark themes for consistency.
class ChallengeSelectionScreen extends StatefulWidget {
  const ChallengeSelectionScreen({
    super.key,
    required this.onChallengeSelected,
    required this.onBack,
  });

  final void Function(ChallengeTypeInfo info) onChallengeSelected;
  final VoidCallback onBack;

  @override
  State<ChallengeSelectionScreen> createState() =>
      _ChallengeSelectionScreenState();
}

class _ChallengeSelectionScreenState extends State<ChallengeSelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeColor = isDark ? pvzOrangeDark : pvzOrangeLight;
    final challenges = _searchQuery.trim().isEmpty
        ? ChallengeRepository.allChallenges
        : ChallengeRepository.search(_searchQuery, context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: l10n?.searchChallengeNameOrCode ?? 'Search challenge name or code',
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: theme.colorScheme.onSurfaceVariant),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => widget.onChallengeSelected(challenge),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: themeColor.withValues(alpha: 0.5)),
                      ),
                      child: Icon(challenge.icon, size: 32, color: themeColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.localizedTitle(context),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            challenge.localizedDescription(context),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            challenge.objClass,
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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

