import 'package:flutter/material.dart';

import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Shared preset picker used by compatible zombie-spawning events.
class JitterOffsetsBindingCard extends StatelessWidget {
  const JitterOffsetsBindingCard({
    super.key,
    required this.levelFile,
    required this.currentValue,
    required this.onChanged,
    required this.onManage,
    this.overrideWarning,
    this.enabled = true,
  });

  final PvzLevelFile levelFile;
  final String? currentValue;
  final ValueChanged<String?> onChanged;
  final VoidCallback onManage;
  final String? overrideWarning;
  final bool enabled;

  Future<void> _showPresetPicker({
    required BuildContext context,
    required List<String> choices,
    required String selectedAlias,
    required String Function(String alias) labelFor,
    required bool Function(String alias) isEnabled,
    required ValueChanged<String> onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _JitterOffsetsPresetPickerSheet(
        choices: choices,
        selectedAlias: selectedAlias,
        labelFor: labelFor,
        isEnabled: isEnabled,
      ),
    );
    if (selected == null) return;
    onSelected(selected);
  }

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

    final hasBinding = currentValue?.trim().isNotEmpty == true;
    final boundInfo = hasBinding ? RtidParser.parse(currentValue!) : null;
    final boundAlias = boundInfo?.alias;
    final boundIsLocal = boundInfo?.source == 'CurrentLevel';
    final boundPreset = boundIsLocal && boundAlias != null
        ? presetsByAlias[boundAlias]
        : null;
    final dangling = hasBinding && (!boundIsLocal || boundPreset == null);
    final danglingLabel = boundAlias ?? currentValue?.trim() ?? '';
    final danglingChoice = dangling ? '\u0000dangling:$currentValue' : null;
    final invalid =
        boundPreset != null && !JitterOffsetsUtils.isPresetValid(boundPreset);
    final choices = <String>['', ...presetsByAlias.keys, ?danglingChoice];

    String labelFor(String choice) {
      if (choice.isEmpty) {
        return l10n?.jitterOffsetsEventNone ??
            'Unbound (use the game\'s default parameters: 80 / 30)';
      }
      if (choice == danglingChoice) {
        return l10n?.jitterOffsetsEventDangling(danglingLabel) ??
            '$danglingLabel (missing)';
      }
      final preset = presetsByAlias[choice];
      if (preset != null && !JitterOffsetsUtils.isPresetValid(preset)) {
        return l10n?.jitterOffsetsEventInvalidOption(choice) ??
            '$choice (invalid values)';
      }
      return choice;
    }

    final errorText = !enabled
        ? null
        : dangling
        ? (l10n?.jitterOffsetsEventDangling(danglingLabel) ??
              '$danglingLabel (missing)')
        : invalid
        ? (l10n?.jitterOffsetsEventInvalidPreset ??
              'This preset contains invalid parameters. Under "Manage Presets", set "Random offset upper bound" to a positive value.')
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n?.jitterOffsetsEventLabel ?? 'Spawn Position Offset',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.secondary,
                  ),
                  onPressed: onManage,
                  child: Text(
                    l10n?.jitterOffsetsEventManage ?? 'Manage presets',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              key: const ValueKey('jitterOffsetsPresetPicker'),
              borderRadius: BorderRadius.circular(4),
              onTap: enabled
                  ? () => _showPresetPicker(
                      context: context,
                      choices: choices,
                      selectedAlias: danglingChoice ?? boundAlias ?? '',
                      labelFor: labelFor,
                      isEnabled: (choice) {
                        if (choice == danglingChoice) return false;
                        final preset = presetsByAlias[choice];
                        final isInvalidOption =
                            preset != null &&
                            !JitterOffsetsUtils.isPresetValid(preset);
                        return choice.isEmpty || !isInvalidOption;
                      },
                      onSelected: (alias) {
                        if (alias.isEmpty) {
                          onChanged(null);
                          return;
                        }
                        onChanged(RtidParser.build(alias, 'CurrentLevel'));
                      },
                    )
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  enabled: enabled,
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  errorText: errorText,
                  errorMaxLines: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        labelFor(danglingChoice ?? boundAlias ?? ''),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: enabled ? null : theme.disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            if (overrideWarning case final warning?) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      warning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (errorText == null) ...[
              const SizedBox(height: 8),
              Text(
                l10n?.jitterOffsetsEventDescription ??
                    'Controls the horizontal offset added to each zombie\'s base spawn position within the same event and row. Facing determines the offset direction.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Event-local advanced controls that override the bound position-offset
/// preset. This deliberately lives outside the preset editor because
/// `FixedOffset` belongs to each spawn event rather than to
/// `ZombieJitterOffsets`.
class FixedOffsetAdvancedSettingsCard extends StatelessWidget {
  const FixedOffsetAdvancedSettingsCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final num? value;
  final ValueChanged<num> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final initialValue = value ?? 0;
    final initialText = initialValue == initialValue.truncateToDouble()
        ? initialValue.toInt().toString()
        : initialValue.toString();

    return Card(
      child: ExpansionTile(
        key: const ValueKey('fixedOffsetAdvancedSettings'),
        title: Text(
          l10n?.jitterOffsetsAdvancedSettingsTitle ?? 'Advanced settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          EditorResponsiveInputField(
            label:
                l10n?.jitterOffsetsFixedOffsetLabel ??
                'Global-index fixed offset (FixedOffset)',
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              helperText:
                  l10n?.jitterOffsetsFixedOffsetDescription ??
                  'The default is 0. With a nonzero value, zombies are numbered in creation order across the whole batch, starting at 0. Each zombie\'s base horizontal position receives its index multiplied by the fixed offset value. The index does not reset by row, and facing does not change the offset direction: a positive fixed offset value moves zombies right, while a negative value moves them left. Therefore, use this setting carefully when one event contains zombies in different rows or with different facings.\nThe Spawn Position Offset preset and spawn arrangement are temporarily ignored but retained; they take effect again when this value is restored to 0. Spawn arrangement is the game\'s rule for row starting offsets and offsets between rows.',
              helperMaxLines: 20,
            ),
            builder: (context, decoration) => TextFormField(
              key: const ValueKey('fixedOffsetField'),
              initialValue: initialText,
              decoration: decoration,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                final parsed = num.tryParse(text?.trim() ?? '');
                if (parsed != null && parsed.isFinite) return null;
                return l10n?.jitterOffsetsFixedOffsetInvalid ??
                    'Enter a valid number.';
              },
              onChanged: (text) {
                final parsed = num.tryParse(text.trim());
                if (parsed != null && parsed.isFinite) onChanged(parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _JitterOffsetsPresetPickerSheet extends StatefulWidget {
  const _JitterOffsetsPresetPickerSheet({
    required this.choices,
    required this.selectedAlias,
    required this.labelFor,
    required this.isEnabled,
  });

  final List<String> choices;
  final String selectedAlias;
  final String Function(String alias) labelFor;
  final bool Function(String alias) isEnabled;

  @override
  State<_JitterOffsetsPresetPickerSheet> createState() =>
      _JitterOffsetsPresetPickerSheetState();
}

class _JitterOffsetsPresetPickerSheetState
    extends State<_JitterOffsetsPresetPickerSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              l10n?.jitterOffsetsEventLabel ?? 'Spawn Position Offset',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              scrollbarOrientation: ScrollbarOrientation.right,
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 10, bottom: 16),
                itemCount: widget.choices.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final alias = widget.choices[index];
                  final enabled = widget.isEnabled(alias);
                  return ListTile(
                    enabled: enabled,
                    selected: alias == widget.selectedAlias,
                    title: Text(widget.labelFor(alias), softWrap: true),
                    trailing: alias == widget.selectedAlias
                        ? Icon(Icons.check, color: theme.colorScheme.secondary)
                        : null,
                    onTap: enabled ? () => Navigator.pop(context, alias) : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
