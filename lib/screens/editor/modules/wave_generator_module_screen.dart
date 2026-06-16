import 'package:flutter/material.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/data/repository/zombie_repository.dart';
import 'package:c_editor/data/wave_generator_level_utils.dart';
import 'package:c_editor/data/zombie_display_utils.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/theme/app_theme.dart';
import 'package:c_editor/widgets/editor_components.dart';
import 'package:c_editor/widgets/wave_generator_zombie_tile.dart';

/// Global settings editor for [WaveGeneratorProperties].
class WaveGeneratorModuleScreen extends StatefulWidget {
  const WaveGeneratorModuleScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
    required this.onRequestZombieSelection,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;
  final void Function(void Function(String) onSelected)
      onRequestZombieSelection;

  @override
  State<WaveGeneratorModuleScreen> createState() =>
      _WaveGeneratorModuleScreenState();
}

class _WaveGeneratorModuleScreenState extends State<WaveGeneratorModuleScreen> {
  late PvzObject _moduleObj;
  late WaveGeneratorPropertiesData _data;
  late TextEditingController _flagIntervalCtrl;
  late TextEditingController _spendingPointsCtrl;
  late TextEditingController _spendingIncrementCtrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _moduleObj = WaveGeneratorLevelUtils.loadOrCreate(
      widget.levelFile,
      widget.rtid,
    );
    _data = WaveGeneratorLevelUtils.parseObject(_moduleObj);
    _flagIntervalCtrl = TextEditingController(
      text: '${_data.flagWaveInterval}',
    );
    _spendingPointsCtrl = TextEditingController(
      text: '${_data.waveSpendingPoints}',
    );
    _spendingIncrementCtrl = TextEditingController(
      text: '${_data.waveSpendingPointIncrement}',
    );
  }

  void _sync() {
    _data.syncWaveCount();
    _moduleObj.objData = _data.toJson();
    WaveGeneratorLevelUtils.writeData(widget.levelFile, _data);
    widget.onChanged();
    setState(() {});
  }

  bool _isYetiZombie(String id) {
    return id == 'yeti' ||
        id == 'treasureyeti' ||
        id == 'treasureyeti_egypt';
  }

  void _showYetiZombieBlockedMessage(AppLocalizations? l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.yetiZombiesNotAllowed ?? 'Yetis are not allowed here',
        ),
      ),
    );
  }

  void _addPoolZombie() {
    final l10n = AppLocalizations.of(context);
    widget.onRequestZombieSelection((selectedId) {
      if (_isYetiZombie(selectedId)) {
        _showYetiZombieBlockedMessage(l10n);
        return;
      }
      if (ZombieRepository().isElite(selectedId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.eliteZombiesNotAllowed ?? 'Elite zombies are not allowed here',
            ),
          ),
        );
        return;
      }
      final rtid = RtidParser.build(
        ZombieRepository().buildZombieAliases(selectedId),
        'ZombieTypes',
      );
      if (RtidParser.parse(rtid)?.source == 'CurrentLevel') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.waveGeneratorCustomZombieBlocked ??
                  'Custom zombies are not supported in wave generator levels.',
            ),
          ),
        );
        return;
      }
      _data = WaveGeneratorPropertiesData(
        addToZombiePool: [
          ..._data.addToZombiePool,
          WaveGeneratorPoolEntryData(type: rtid),
        ],
        flagWaveInterval: _data.flagWaveInterval,
        waveCount: _data.waveCount,
        waveSpendingPoints: _data.waveSpendingPoints,
        waveSpendingPointIncrement: _data.waveSpendingPointIncrement,
        waves: _data.waves,
      );
      _sync();
    });
  }

  void _removePoolZombie(int index) {
    final pool = List<WaveGeneratorPoolEntryData>.from(_data.addToZombiePool)
      ..removeAt(index);
    _data = WaveGeneratorPropertiesData(
      addToZombiePool: pool,
      flagWaveInterval: _data.flagWaveInterval,
      waveCount: _data.waveCount,
      waveSpendingPoints: _data.waveSpendingPoints,
      waveSpendingPointIncrement: _data.waveSpendingPointIncrement,
      waves: _data.waves,
    );
    _sync();
  }

  String _zombieDisplayName(String rtid) {
    return ZombieDisplayUtils.localizedName(
      context,
      typeOrRtid: rtid,
      levelFile: widget.levelFile,
    );
  }

  String _zombieCodename(String rtid) {
    return ZombieDisplayUtils.codename(rtid);
  }

  String? _zombieIcon(String rtid) {
    return ZombieDisplayUtils.iconPath(rtid, levelFile: widget.levelFile);
  }

  @override
  void dispose() {
    _flagIntervalCtrl.dispose();
    _spendingPointsCtrl.dispose();
    _spendingIncrementCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sectionTitleColor = theme.brightness == Brightness.dark
        ? pvzPurpleDark
        : pvzPurpleLight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n?.back ?? 'Back',
          onPressed: widget.onBack,
        ),
        backgroundColor: sectionTitleColor,
        foregroundColor: Colors.white,
        title: Text(l10n?.waveGeneratorModuleTitle ?? 'Wave Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n?.tooltipAboutModule ?? 'About this module',
            onPressed: () => showEditorHelpDialog(
              context,
              title: l10n?.waveGeneratorModuleHelpTitle ?? 'Wave Generator',
              themeColor: sectionTitleColor,
              sections: [
                HelpSectionData(
                  title: l10n?.waveGeneratorModuleHelpOverview ?? 'Overview',
                  body: l10n?.waveGeneratorModuleHelpOverviewBody ??
                      'Legacy embedded wave definition used in campaign-style levels. Edit individual waves on the Waves tab.',
                ),
                HelpSectionData(
                  title: l10n?.waveGeneratorModuleHelpSpending ?? 'Spending points',
                  body: l10n?.waveGeneratorModuleHelpSpendingBody ??
                      'WaveSpendingPoints must be less than or equal to WaveSpendingPointIncrement or the level crashes on load.',
                ),
                HelpSectionData(
                  title: l10n?.waveGeneratorModuleHelpPool ?? 'Zombie pool',
                  body: l10n?.waveGeneratorModuleHelpPoolBody ??
                      'AddToZombiePool extends random spawn options. Only built-in zombie types are supported.',
                ),
                HelpSectionData(
                  title: l10n?.waveGeneratorModuleHelpIncompat ?? 'Incompatibilities',
                  body: l10n?.waveGeneratorModuleHelpIncompatBody ??
                      'Cannot coexist with Wave Manager modules, Renai, or Witch modules.',
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                      l10n?.waveGeneratorModuleGlobalParams ??
                          'Global parameters',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _flagIntervalCtrl,
                      decoration: InputDecoration(
                        labelText: l10n?.flagWaveInterval ??
                            'Flag wave interval (FlagWaveInterval)',
                        border: const OutlineInputBorder(),
                        helperText: l10n?.waveGeneratorFlagIntervalHint,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        final n = int.tryParse(v);
                        if (n != null && n > 0) {
                          _data.flagWaveInterval = n;
                          _sync();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _spendingPointsCtrl,
                            decoration: InputDecoration(
                              labelText: l10n?.waveGeneratorSpendingPoints ??
                                  'Spending points (WaveSpendingPoints)',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null) {
                                _data.waveSpendingPoints = n;
                                _sync();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _spendingIncrementCtrl,
                            decoration: InputDecoration(
                              labelText:
                                  l10n?.waveGeneratorSpendingPointIncrement ??
                                      'Point increment (WaveSpendingPointIncrement)',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null) {
                                _data.waveSpendingPointIncrement = n;
                                _sync();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.waveGeneratorWaveCountSummary(_data.waves.length) ??
                          'Waves: ${_data.waves.length} (edit on Waves tab)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n?.waveGeneratorInitialPool ??
                                'Initial zombie pool (AddToZombiePool)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: l10n?.addType ?? 'Add',
                          onPressed: _addPoolZombie,
                        ),
                      ],
                    ),
                    if (_data.addToZombiePool.isEmpty)
                      Text(
                        l10n?.waveGeneratorEmptyPool ??
                            'No zombies in the initial pool.',
                        style: theme.textTheme.bodySmall,
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var i = 0; i < _data.addToZombiePool.length; i++)
                            WaveGeneratorZombieTile(
                              style: WaveGeneratorZombieTileStyle.poolCompact,
                              localizedName: _zombieDisplayName(
                                _data.addToZombiePool[i].type,
                              ),
                              codename: _zombieCodename(
                                _data.addToZombiePool[i].type,
                              ),
                              iconPath: _zombieIcon(
                                _data.addToZombiePool[i].type,
                              ),
                              onDelete: () => _removePoolZombie(i),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
