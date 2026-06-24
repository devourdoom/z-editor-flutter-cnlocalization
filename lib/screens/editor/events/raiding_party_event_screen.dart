import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:c_editor/data/level_parser.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Raiding party event editor. Ported from Z-Editor-master RaidingPartyEventEP.kt
class RaidingPartyEventScreen extends StatefulWidget {
  const RaidingPartyEventScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;

  @override
  State<RaidingPartyEventScreen> createState() =>
      _RaidingPartyEventScreenState();
}

class _RaidingPartyEventScreenState extends State<RaidingPartyEventScreen> {
  late PvzObject _moduleObj;
  late RaidingPartyEventData _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final alias = LevelParser.extractAlias(widget.rtid);
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: 'RaidingPartyZombieSpawnerProps',
        objData: RaidingPartyEventData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = RaidingPartyEventData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = RaidingPartyEventData();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final alias = LevelParser.extractAlias(widget.rtid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n?.editAlias(alias) ?? 'Edit $alias'),
            Text(
              l10n?.eventRaidingParty ?? 'Event: Raiding party',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: l10n?.eventRaidingParty ?? 'Raiding party event',
              sections: [
                HelpSectionData(
                  title: l10n?.overview ?? 'Overview',
                  body: l10n?.eventHelpRaidingPartyBody ?? '',
                ),
                HelpSectionData(
                  title: l10n?.groupSize ?? 'Group size',
                  body: l10n?.eventHelpRaidingPartyGroup ?? '',
                ),
                HelpSectionData(
                  title: l10n?.swashbucklerCount ?? 'Swashbuckler count',
                  body: l10n?.eventHelpRaidingPartyCount ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spawn parameters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIntField(
                        theme,
                        'Group size (GroupSize)',
                        _data.groupSize,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: v,
                            swashbucklerCount: _data.swashbucklerCount,
                            timeBetweenGroups: _data.timeBetweenGroups,
                          );
                          _sync();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildIntField(
                        theme,
                        'Total zombies (SwashbucklerCount)',
                        _data.swashbucklerCount,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: _data.groupSize,
                            swashbucklerCount: v,
                            timeBetweenGroups: _data.timeBetweenGroups,
                          );
                          _sync();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildIntField(
                        theme,
                        'Time between groups (TimeBetweenGroups)',
                        _data.timeBetweenGroups,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: _data.groupSize,
                            swashbucklerCount: _data.swashbucklerCount,
                            timeBetweenGroups: v,
                          );
                          _sync();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntField(
    ThemeData theme,
    String label,
    int value,
    void Function(int) onChanged,
  ) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) {
        final n = int.tryParse(v);
        if (n != null) onChanged(n);
      },
    );
  }
}
