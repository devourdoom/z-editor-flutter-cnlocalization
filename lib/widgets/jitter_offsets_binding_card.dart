import 'package:flutter/material.dart';

import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/l10n/app_localizations.dart';

/// Shared preset picker used by Basic Spawner and Underwater Spawner events.
class JitterOffsetsBindingCard extends StatelessWidget {
  const JitterOffsetsBindingCard({
    super.key,
    required this.levelFile,
    required this.currentValue,
    required this.onChanged,
    required this.onManage,
  });

  final PvzLevelFile levelFile;
  final String? currentValue;
  final ValueChanged<String?> onChanged;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final presets = JitterOffsetsUtils.listPresets(levelFile);
    final presetsByAlias = <String, PvzObject>{};
    for (final preset in presets) {
      final aliases = preset.aliases;
      if (aliases == null || aliases.isEmpty || aliases.first.isEmpty) {
        continue;
      }
      presetsByAlias.putIfAbsent(aliases.first, () => preset);
    }

    final boundInfo = currentValue == null
        ? null
        : RtidParser.parse(currentValue!);
    final boundAlias = boundInfo?.alias;
    final boundPreset = boundAlias == null ? null : presetsByAlias[boundAlias];
    final dangling = boundAlias != null && boundPreset == null;
    final invalid =
        boundPreset != null && !JitterOffsetsUtils.isPresetValid(boundPreset);
    final choices = <String>['', ...presetsByAlias.keys];
    if (dangling && !choices.contains(boundAlias)) choices.add(boundAlias);

    String labelFor(String alias) {
      if (alias.isEmpty) {
        return l10n?.jitterOffsetsEventNone ??
            'Off (use the game\'s default parameters)';
      }
      if (dangling && alias == boundAlias) {
        return l10n?.jitterOffsetsEventDangling(alias) ?? '$alias (missing)';
      }
      final preset = presetsByAlias[alias];
      if (preset != null && !JitterOffsetsUtils.isPresetValid(preset)) {
        return l10n?.jitterOffsetsEventInvalidOption(alias) ??
            '$alias (invalid values)';
      }
      return alias;
    }

    final errorText = dangling
        ? (l10n?.jitterOffsetsEventDangling(boundAlias) ??
              '$boundAlias (missing)')
        : invalid
        ? (l10n?.jitterOffsetsEventInvalidPreset ??
              'This preset contains invalid parameters. Under "Manage Presets", set "Same-row spawn interval" to a non-negative value and "Random jitter" to a positive value.')
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n?.jitterOffsetsEventLabel ?? 'Spawn Jitter Offset',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onManage,
                  child: Text(
                    l10n?.jitterOffsetsEventManage ?? 'Manage presets',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: boundAlias ?? '',
              isExpanded: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorText: errorText,
                errorMaxLines: 3,
              ),
              items: choices.map((alias) {
                final preset = presetsByAlias[alias];
                final isInvalidOption =
                    preset != null && !JitterOffsetsUtils.isPresetValid(preset);
                return DropdownMenuItem<String>(
                  value: alias,
                  enabled:
                      alias.isEmpty ||
                      (!isInvalidOption && !(dangling && alias == boundAlias)),
                  child: Text(
                    labelFor(alias),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (alias) {
                if (alias == null) return;
                if (alias.isEmpty) {
                  onChanged(null);
                  return;
                }
                onChanged(
                  RtidParser.build(alias, boundInfo?.source ?? 'CurrentLevel'),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              presets.isEmpty
                  ? (l10n?.jitterOffsetsEventNoPresets ??
                        'No presets yet. This event will automatically use the game\'s default parameters. If you need custom spacing, create a preset first.')
                  : (l10n?.jitterOffsetsEventDescription ??
                        'Controls the distance between the off-lawn spawn positions of zombies in the same row. Without a bound preset, the event uses the game\'s default parameters and still spawns normally.'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: errorText == null
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
