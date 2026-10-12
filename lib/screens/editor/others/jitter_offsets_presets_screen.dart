import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/theme/app_theme.dart';
import 'package:c_editor/widgets/alias_input_validation.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Manages the level-local [ZombieJitterOffsetsData] objects referenced by
/// Basic Spawner and Underwater Spawner events.
///
/// These presets are independent level objects; they are intentionally not
/// inserted into `LevelDefinition.Modules`.
class JitterOffsetsPresetsScreen extends StatefulWidget {
  const JitterOffsetsPresetsScreen({
    super.key,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
  });

  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;

  @override
  State<JitterOffsetsPresetsScreen> createState() =>
      _JitterOffsetsPresetsScreenState();
}

class _JitterOffsetsPresetsScreenState
    extends State<JitterOffsetsPresetsScreen> {
  Color _themeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? pvzOrangeDark
      : pvzOrangeLight;

  List<PvzObject> get _presets =>
      JitterOffsetsUtils.listPresets(widget.levelFile);

  String _aliasOf(PvzObject preset) {
    final aliases = preset.aliases;
    return aliases == null || aliases.isEmpty ? '' : aliases.first;
  }

  ZombieJitterOffsetsData _dataOf(PvzObject preset) {
    return JitterOffsetsUtils.dataOf(preset);
  }

  void _writeData(PvzObject preset, ZombieJitterOffsetsData updated) {
    final previous = preset.objData;
    if (previous is Map) {
      // Preserve any unknown fields imported from a newer game/editor build.
      preset.objData = <String, dynamic>{
        ...Map<String, dynamic>.from(previous),
        ...updated.toJson(),
      };
    } else {
      preset.objData = updated.toJson();
    }
    widget.onChanged();
  }

  void _addPreset() {
    final alias = JitterOffsetsUtils.nextAlias(widget.levelFile);
    widget.levelFile.objects.add(
      PvzObject(
        aliases: <String>[alias],
        objClass: JitterOffsetsUtils.objectClass,
        objData: ZombieJitterOffsetsData().toJson(),
      ),
    );
    widget.onChanged();
    setState(() {});

    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            l10n?.jitterOffsetsCreated(alias) ?? 'Created preset $alias',
          ),
        ),
      );
  }

  Future<void> _renamePreset(PvzObject preset) async {
    final l10n = AppLocalizations.of(context);
    final oldAlias = _aliasOf(preset);
    if (oldAlias.isEmpty) return;

    var input = oldAlias;
    String? errorText;
    final newAlias = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          void submit() {
            final candidate = input;
            final error = _validateAlias(preset, candidate, l10n);
            if (error != null) {
              setDialogState(() => errorText = error);
              return;
            }
            Navigator.pop(dialogContext, candidate);
          }

          return AlertDialog(
            title: Text(l10n?.jitterOffsetsRenameTitle ?? 'Rename Preset'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.jitterOffsetsRenameDescription ??
                        'After renaming, every event that references this preset is updated automatically.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: oldAlias,
                    autofocus: true,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => submit(),
                    onChanged: (value) {
                      input = value;
                      if (errorText != null) {
                        setDialogState(() => errorText = null);
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          l10n?.aliasLabel ??
                          'Alias (English letters only; no spaces)',
                      errorText: errorText,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n?.cancel ?? 'Cancel'),
              ),
              FilledButton(
                onPressed: submit,
                child: Text(l10n?.confirm ?? 'Confirm'),
              ),
            ],
          );
        },
      ),
    );
    if (!mounted || newAlias == null || newAlias == oldAlias) return;
    preset.aliases = <String>[newAlias, ...?preset.aliases?.skip(1)];
    final updatedCount = JitterOffsetsUtils.renamePresetReferences(
      widget.levelFile,
      oldAlias,
      newAlias,
    );
    widget.onChanged();
    setState(() {});

    if (updatedCount > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n?.jitterOffsetsRenamed(updatedCount) ??
                  'Updated references in $updatedCount event(s)',
            ),
          ),
        );
    }
  }

  String? _validateAlias(
    PvzObject preset,
    String alias,
    AppLocalizations? l10n,
  ) {
    if (alias.isEmpty) {
      return l10n?.aliasEmpty ?? 'Alias cannot be empty';
    }
    final characterError = aliasCharacterValidationError(l10n, alias);
    if (characterError != null) return characterError;
    if (alias.contains('@') || alias.contains('(') || alias.contains(')')) {
      return l10n?.jitterOffsetsAliasBadChars ??
          'Alias cannot contain @ ( ), or it cannot be parsed correctly';
    }
    final taken = widget.levelFile.objects.any(
      (object) =>
          !identical(object, preset) &&
          (object.aliases?.contains(alias) ?? false),
    );
    if (taken) {
      return l10n?.jitterOffsetsAliasTaken(alias) ??
          'Alias $alias is already used by another object';
    }
    return null;
  }

  Future<void> _requestDelete(PvzObject preset) async {
    final l10n = AppLocalizations.of(context);
    final alias = _aliasOf(preset);
    final referrers = alias.isEmpty
        ? const <PvzObject>[]
        : JitterOffsetsUtils.findReferrers(widget.levelFile, alias);

    if (referrers.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n?.jitterOffsetsDeleteBlockedTitle ?? 'Cannot Delete'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.jitterOffsetsDeleteBlockedDescription(
                          alias,
                          referrers.length,
                        ) ??
                        'Preset $alias is still referenced by '
                            '${referrers.length} spawn event(s) and cannot be deleted.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n?.jitterOffsetsDeleteBlockedHint ??
                        'Open these events first and switch "Spawn Jitter Offset" to another preset or turn it off:',
                    style: Theme.of(dialogContext).textTheme.bodySmall
                        ?.copyWith(
                          color: Theme.of(
                            dialogContext,
                          ).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 6),
                  for (final referrer in referrers.take(10))
                    Text(
                      '• ${_referrerLabel(referrer)}',
                      style: Theme.of(dialogContext).textTheme.bodySmall
                          ?.copyWith(
                            color: Theme.of(
                              dialogContext,
                            ).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  if (referrers.length > 10) const Text('…'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n?.helpDialogGotIt ?? 'Got it'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.jitterOffsetsDeleteTitle ?? 'Delete Preset?'),
        content: Text(
          l10n?.jitterOffsetsDeleteDescription(alias) ??
              'Preset $alias will be deleted. No event references it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n?.jitterOffsetsDelete ?? 'Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    widget.levelFile.objects.removeWhere((object) => identical(object, preset));
    widget.onChanged();
    setState(() {});
  }

  String _referrerLabel(PvzObject referrer) {
    final aliases = referrer.aliases;
    if (aliases != null && aliases.isNotEmpty && aliases.first.isNotEmpty) {
      return aliases.first;
    }
    return referrer.objClass;
  }

  void _showHelp() {
    final l10n = AppLocalizations.of(context);
    showEditorHelpDialog(
      context,
      title: l10n?.jitterOffsetsHelpTitle ?? 'Spawn Jitter Offsets',
      themeColor: _themeColor(context),
      useNeutralSectionTitles: true,
      sections: [
        HelpSectionData(
          title: l10n?.jitterOffsetsHelpOverviewTitle ?? 'Overview',
          body:
              l10n?.jitterOffsetsHelpOverviewBody ??
              'In Basic Spawner and Underwater Spawner events, zombies in the same row spawn one after another outside the lawn. Spawn jitter offset presets control the distance between their spawn positions. Events that are not bound to a preset use the game\'s default parameters and still spawn normally, so no default preset is provided. Configure this feature only when needed.',
        ),
        HelpSectionData(
          title: l10n?.jitterOffsetsHelpUsageTitle ?? 'Instructions',
          body:
              l10n?.jitterOffsetsHelpUsageBody ??
              'After creating a preset here, open any Basic Spawner or Underwater Spawner event and select it under "Spawn Jitter Offset".\nA preset can be shared by multiple events. Editing it updates every event that references it. A referenced preset cannot be deleted; first switch those events to another preset or turn the feature off.',
        ),
        HelpSectionData(
          title: l10n?.jitterOffsetsHelpParametersTitle ?? 'Parameters',
          body:
              l10n?.jitterOffsetsHelpParametersBody ??
              '"Same-row spawn interval" is the base distance between the off-lawn spawn positions of adjacent zombies in the same row. Use a non-negative value; negative values may prevent the level from settling normally.\n"Random jitter" is the range randomly added to or subtracted from the base distance. Use a positive value. A value of 0 causes zombies to be killed immediately before appearing, while negative values may prevent the level from settling normally.\nThe actual distance between spawn positions is randomly selected within "Same-row spawn interval ± Random jitter".',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final themeColor = _themeColor(context);
    final presets = _presets;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.jitterOffsetsPageTitle ?? 'Spawn Jitter Offset Presets',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              l10n?.jitterOffsetsPageCount(presets.length) ??
                  '${presets.length} preset(s)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
        backgroundColor: themeColor,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            tooltip: l10n?.jitterOffsetsHelpTitle ?? 'Help',
            onPressed: _showHelp,
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (presets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    l10n?.jitterOffsetsEmpty ??
                        'No presets yet.\nBasic Spawner and Underwater Spawner events without a bound preset use the game\'s default parameters.\nIf you need custom spacing, create a preset and bind it in the event.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              for (final preset in presets) ...[
                _JitterOffsetsPresetCard(
                  key: ObjectKey(preset),
                  preset: preset,
                  alias: _aliasOf(preset),
                  data: _dataOf(preset),
                  referrers: _aliasOf(preset).isEmpty
                      ? const <PvzObject>[]
                      : JitterOffsetsUtils.findReferrers(
                          widget.levelFile,
                          _aliasOf(preset),
                        ),
                  themeColor: themeColor,
                  onIncrementChanged: (value) {
                    final current = _dataOf(preset);
                    _writeData(
                      preset,
                      ZombieJitterOffsetsData(
                        offsetIncrement: value,
                        randomJitter: current.randomJitter,
                      ),
                    );
                  },
                  onRandomJitterChanged: (value) {
                    final current = _dataOf(preset);
                    _writeData(
                      preset,
                      ZombieJitterOffsetsData(
                        offsetIncrement: current.offsetIncrement,
                        randomJitter: value,
                      ),
                    );
                  },
                  onRename: () => _renamePreset(preset),
                  onDelete: () => _requestDelete(preset),
                ),
                const SizedBox(height: 12),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: OutlinedButton.icon(
                  onPressed: _addPreset,
                  icon: const Icon(Icons.add_circle_outline),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(l10n?.jitterOffsetsAdd ?? 'New Preset'),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeColor,
                    side: BorderSide(color: themeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _JitterOffsetsPresetCard extends StatelessWidget {
  const _JitterOffsetsPresetCard({
    super.key,
    required this.preset,
    required this.alias,
    required this.data,
    required this.referrers,
    required this.themeColor,
    required this.onIncrementChanged,
    required this.onRandomJitterChanged,
    required this.onRename,
    required this.onDelete,
  });

  final PvzObject preset;
  final String alias;
  final ZombieJitterOffsetsData data;
  final List<PvzObject> referrers;
  final Color themeColor;
  final ValueChanged<int> onIncrementChanged;
  final ValueChanged<int> onRandomJitterChanged;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alias.isEmpty
                            ? (l10n?.jitterOffsetsNoAlias ?? '(no alias)')
                            : alias,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: alias.isEmpty
                              ? theme.colorScheme.error
                              : themeColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (referrers.isEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                l10n?.jitterOffsetsUnused ??
                                    'Not referenced by any spawn event',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          l10n?.jitterOffsetsReferenced(referrers.length) ??
                              'Referenced by ${referrers.length} spawn event(s)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n?.jitterOffsetsRename ?? 'Rename',
                  onPressed: alias.isEmpty ? null : onRename,
                  icon: const Icon(Icons.drive_file_rename_outline),
                ),
                IconButton(
                  tooltip: l10n?.jitterOffsetsDelete ?? 'Delete',
                  onPressed: onDelete,
                  color: theme.colorScheme.error,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SignedIntegerField(
              key: ValueKey('${identityHashCode(preset)}:increment'),
              label:
                  l10n?.jitterOffsetsIncrementLabel ??
                  'Same-row spawn interval (ZombieSpawningOffsetIncrement)',
              initialValue: data.offsetIncrement,
              themeColor: themeColor,
              validator: (value) {
                if (value == null) {
                  return l10n?.jitterOffsetsIntegerInvalid ??
                      'Enter a valid integer.';
                }
                if (value < 0) {
                  return l10n?.jitterOffsetsIncrementInvalid ??
                      'Use a non-negative same-row spawn interval. Negative values may prevent the level from settling normally.';
                }
                return null;
              },
              onChanged: onIncrementChanged,
            ),
            const SizedBox(height: 12),
            _SignedIntegerField(
              key: ValueKey('${identityHashCode(preset)}:jitter'),
              label:
                  l10n?.jitterOffsetsRandomJitterLabel ??
                  'Random jitter (ZombieSpawningRandomJitter)',
              initialValue: data.randomJitter,
              themeColor: themeColor,
              validator: (value) {
                if (value == null) {
                  return l10n?.jitterOffsetsIntegerInvalid ??
                      'Enter a valid integer.';
                }
                if (value <= 0) {
                  return l10n?.jitterOffsetsRandomJitterInvalid ??
                      'Use a positive random jitter. A value of 0 causes zombies to be killed immediately before appearing; negative values may prevent the level from settling normally.';
                }
                return null;
              },
              onChanged: onRandomJitterChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedIntegerField extends StatelessWidget {
  const _SignedIntegerField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.themeColor,
    required this.validator,
    required this.onChanged,
  });

  final String label;
  final int initialValue;
  final Color themeColor;
  final String? Function(int? value) validator;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return EditorResponsiveInputField(
      label: label,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      builder: (context, decoration) => TextFormField(
        initialValue: '$initialValue',
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
        ],
        maxLines: 1,
        autovalidateMode: AutovalidateMode.always,
        validator: (raw) => validator(int.tryParse(raw ?? '')),
        decoration: decoration.copyWith(
          errorMaxLines: 3,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeColor, width: 2),
          ),
          floatingLabelStyle: TextStyle(color: themeColor),
        ),
        onChanged: (raw) {
          final value = int.tryParse(raw);
          if (validator(value) == null && value != null) onChanged(value);
        },
      ),
    );
  }
}
