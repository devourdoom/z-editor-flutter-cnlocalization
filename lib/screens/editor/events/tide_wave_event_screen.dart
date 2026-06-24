import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Tide wave event editor. Type: left or right.
class TideWaveEventScreen extends StatefulWidget {
  const TideWaveEventScreen({
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
  State<TideWaveEventScreen> createState() => _TideWaveEventScreenState();
}

class _TideWaveEventScreenState extends State<TideWaveEventScreen> {
  late PvzObject _moduleObj;
  late TideWaveWaveActionPropsData _data;

  static const _typeLeft = 'left';
  static const _typeRight = 'right';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: 'TideWaveWaveActionProps',
        objData: TideWaveWaveActionPropsData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = TideWaveWaveActionPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = TideWaveWaveActionPropsData();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  String _typeLabel(String type, AppLocalizations? l10n) {
    switch (type) {
      case _typeLeft:
        return l10n?.tideWaveTypeLeft ?? 'Left';
      case _typeRight:
        return l10n?.tideWaveTypeRight ?? 'Right';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';

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
              l10n?.eventTideWave ?? 'Event: Tide Wave',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: l10n?.eventTideWave ?? 'Tide wave event',
              sections: [
                HelpSectionData(
                  title: l10n?.overview ?? 'Overview',
                  body: l10n?.eventHelpTideWaveBody ?? '',
                ),
                HelpSectionData(
                  title: l10n?.tideWaveHelpType ?? 'Direction',
                  body: l10n?.eventHelpTideWaveType ?? '',
                ),
                HelpSectionData(
                  title: l10n?.tideWaveHelpParams ?? 'Parameters',
                  body: l10n?.eventHelpTideWaveParams ?? '',
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
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.tideWaveType ?? 'Direction',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text(_typeLabel(_typeLeft, l10n)),
                            selected: _data.type == _typeLeft,
                            onSelected: (_) {
                              _data = TideWaveWaveActionPropsData(
                                type: _typeLeft,
                                duration: _data.duration,
                                submarineMovingDistance:
                                    _data.submarineMovingDistance,
                                speedUpDuration: _data.speedUpDuration,
                                speedUpIncreased: _data.speedUpIncreased,
                                submarineMovingTime: _data.submarineMovingTime,
                                zombieMovingSpeed: _data.zombieMovingSpeed,
                              );
                              _sync();
                            },
                          ),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: Text(_typeLabel(_typeRight, l10n)),
                            selected: _data.type == _typeRight,
                            onSelected: (_) {
                              _data = TideWaveWaveActionPropsData(
                                type: _typeRight,
                                duration: _data.duration,
                                submarineMovingDistance:
                                    _data.submarineMovingDistance,
                                speedUpDuration: _data.speedUpDuration,
                                speedUpIncreased: _data.speedUpIncreased,
                                submarineMovingTime: _data.submarineMovingTime,
                                zombieMovingSpeed: _data.zombieMovingSpeed,
                              );
                              _sync();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildField(
                context,
                l10n?.tideWaveDuration ?? 'Duration',
                _data.duration.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: n,
                      submarineMovingDistance: _data.submarineMovingDistance,
                      speedUpDuration: _data.speedUpDuration,
                      speedUpIncreased: _data.speedUpIncreased,
                      submarineMovingTime: _data.submarineMovingTime,
                      zombieMovingSpeed: _data.zombieMovingSpeed,
                    );
                    _sync();
                  }
                },
              ),
              _buildField(
                context,
                l10n?.tideWaveSubmarineMovingDistance ??
                    'Submarine moving distance',
                _data.submarineMovingDistance.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: _data.duration,
                      submarineMovingDistance: n,
                      speedUpDuration: _data.speedUpDuration,
                      speedUpIncreased: _data.speedUpIncreased,
                      submarineMovingTime: _data.submarineMovingTime,
                      zombieMovingSpeed: _data.zombieMovingSpeed,
                    );
                    _sync();
                  }
                },
              ),
              _buildField(
                context,
                l10n?.tideWaveSpeedUpDuration ?? 'Speed up duration',
                _data.speedUpDuration.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: _data.duration,
                      submarineMovingDistance: _data.submarineMovingDistance,
                      speedUpDuration: n,
                      speedUpIncreased: _data.speedUpIncreased,
                      submarineMovingTime: _data.submarineMovingTime,
                      zombieMovingSpeed: _data.zombieMovingSpeed,
                    );
                    _sync();
                  }
                },
              ),
              _buildField(
                context,
                l10n?.tideWaveSpeedUpIncreased ?? 'Speed up increased',
                _data.speedUpIncreased.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: _data.duration,
                      submarineMovingDistance: _data.submarineMovingDistance,
                      speedUpDuration: _data.speedUpDuration,
                      speedUpIncreased: n,
                      submarineMovingTime: _data.submarineMovingTime,
                      zombieMovingSpeed: _data.zombieMovingSpeed,
                    );
                    _sync();
                  }
                },
              ),
              _buildField(
                context,
                l10n?.tideWaveSubmarineMovingTime ?? 'Submarine moving time',
                _data.submarineMovingTime.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: _data.duration,
                      submarineMovingDistance: _data.submarineMovingDistance,
                      speedUpDuration: _data.speedUpDuration,
                      speedUpIncreased: _data.speedUpIncreased,
                      submarineMovingTime: n,
                      zombieMovingSpeed: _data.zombieMovingSpeed,
                    );
                    _sync();
                  }
                },
              ),
              _buildField(
                context,
                l10n?.tideWaveZombieMovingSpeed ?? 'Zombie moving speed',
                _data.zombieMovingSpeed.toString(),
                (v) {
                  final n = double.tryParse(v);
                  if (n != null && n >= 0) {
                    _data = TideWaveWaveActionPropsData(
                      type: _data.type,
                      duration: _data.duration,
                      submarineMovingDistance: _data.submarineMovingDistance,
                      speedUpDuration: _data.speedUpDuration,
                      speedUpIncreased: _data.speedUpIncreased,
                      submarineMovingTime: _data.submarineMovingTime,
                      zombieMovingSpeed: n,
                    );
                    _sync();
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String label,
    String value,
    void Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
      ),
    );
  }
}
