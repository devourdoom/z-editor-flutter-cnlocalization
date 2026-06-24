import 'package:flutter/material.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/rtid_parser.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/theme/app_theme.dart' show pvzCyanDark, pvzCyanLight;
import 'package:c_editor/widgets/editor_components.dart';

class StartingPlantfoodModuleScreen extends StatefulWidget {
  const StartingPlantfoodModuleScreen({
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
  State<StartingPlantfoodModuleScreen> createState() =>
      _StartingPlantfoodModuleScreenState();
}

class _StartingPlantfoodModuleScreenState
    extends State<StartingPlantfoodModuleScreen> {
  late PvzObject _moduleObj;
  late LevelMutatorStartingPlantfoodPropsData _data;
  late TextEditingController _pfController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    _moduleObj = widget.levelFile.objects.firstWhere(
      (o) => o.aliases?.contains(alias) == true,
      orElse: () => PvzObject(
        aliases: [alias],
        objClass: 'LevelMutatorStartingPlantfoodProps',
        objData: LevelMutatorStartingPlantfoodPropsData().toJson(),
      ),
    );
    try {
      _data = LevelMutatorStartingPlantfoodPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = LevelMutatorStartingPlantfoodPropsData();
    }
    _pfController = TextEditingController(
      text: '${_data.startingPlantfoodOverride}',
    );
  }

  void _save() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
  }

  @override
  void dispose() {
    _pfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? pvzCyanDark : pvzCyanLight;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.overrideStartingPlantfood ?? 'Override Starting Plantfood',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n?.back ?? 'Back',
          onPressed: widget.onBack,
        ),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n?.tooltipAboutModule ?? 'About this module',
            onPressed: () {
              showEditorHelpDialog(
                context,
                title:
                    l10n?.startingPlantfoodHelpTitle ??
                    'Starting Plantfood Module',
                themeColor: accentColor,
                sections: [
                  HelpSectionData(
                    title: l10n?.overview ?? 'Overview',
                    body:
                        l10n?.startingPlantfoodHelpOverview ??
                        'This module was originally used to control different difficulty levels in Panchase. Use it to override the initial plant food carried at level start.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.startingPlantfoodOverride ?? 'Starting Plantfood Override',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pfController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    l10n?.enterStartingPlantfoodHint ??
                    'Enter starting plantfood (0+)',
              ),
              onChanged: (value) {
                final parsed =
                    int.tryParse(value) ?? _data.startingPlantfoodOverride;
                setState(() {
                  _data.startingPlantfoodOverride = parsed.clamp(0, 999);
                  _save();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
