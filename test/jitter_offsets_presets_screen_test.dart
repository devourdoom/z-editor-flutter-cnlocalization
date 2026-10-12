import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/others/jitter_offsets_presets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen(PvzLevelFile level, {VoidCallback? onChanged}) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: JitterOffsetsPresetsScreen(
        levelFile: level,
        onChanged: onChanged ?? () {},
        onBack: () {},
      ),
    );
  }

  test('preset validity requires a non-negative interval and positive jitter', () {
    expect(
      JitterOffsetsUtils.isDataValid(
        ZombieJitterOffsetsData(offsetIncrement: 0, randomJitter: 1),
      ),
      isTrue,
    );
    expect(
      JitterOffsetsUtils.isDataValid(
        ZombieJitterOffsetsData(offsetIncrement: -1, randomJitter: 1),
      ),
      isFalse,
    );
    expect(
      JitterOffsetsUtils.isDataValid(
        ZombieJitterOffsetsData(offsetIncrement: 0, randomJitter: 0),
      ),
      isFalse,
    );
    expect(
      JitterOffsetsUtils.isDataValid(
        ZombieJitterOffsetsData(offsetIncrement: 0, randomJitter: -1),
      ),
      isFalse,
    );
  });

  testWidgets('creates unique presets with defaults and edits both values', (
    tester,
  ) async {
    final level = PvzLevelFile(
      objects: [
        PvzObject(
          aliases: ['Offsets'],
          objClass: 'SomeOtherObject',
          objData: <String, dynamic>{},
        ),
      ],
    );
    var changed = 0;

    await tester.pumpWidget(buildScreen(level, onChanged: () => changed++));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Preset'));
    await tester.pumpAndSettle();

    final presets = JitterOffsetsUtils.listPresets(level);
    expect(presets, hasLength(1));
    expect(presets.single.aliases, ['Offsets1']);
    expect(
      presets.single.objData,
      containsPair('ZombieSpawningOffsetIncrement', 80),
    );
    expect(
      presets.single.objData,
      containsPair('ZombieSpawningRandomJitter', 10),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '24');
    await tester.enterText(find.byType(TextFormField).at(1), '3');
    await tester.pump();

    expect(
      presets.single.objData,
      containsPair('ZombieSpawningOffsetIncrement', 24),
    );
    expect(
      presets.single.objData,
      containsPair('ZombieSpawningRandomJitter', 3),
    );
    expect(changed, greaterThanOrEqualTo(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renames references and blocks deletion while referenced', (
    tester,
  ) async {
    final preset = PvzObject(
      aliases: ['Offsets'],
      objClass: JitterOffsetsUtils.objectClass,
      objData: ZombieJitterOffsetsData().toJson(),
    );
    final event = PvzObject(
      aliases: ['Wave1Event1'],
      objClass: 'SpawnZombiesJitteredWaveActionProps',
      objData: <String, dynamic>{'JitterOffsets': 'RTID(Offsets@CurrentLevel)'},
    );
    final level = PvzLevelFile(objects: [preset, event]);

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.drive_file_rename_outline));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'FastOffsets');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(preset.aliases?.first, 'FastOffsets');
    expect(
      (event.objData as Map)['JitterOffsets'],
      'RTID(FastOffsets@CurrentLevel)',
    );

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Cannot Delete'), findsOneWidget);
    expect(find.textContaining('Wave1Event1'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    expect(level.objects, contains(preset));
  });

  testWidgets('rejects spaces and Chinese characters in preset aliases', (
    tester,
  ) async {
    final preset = PvzObject(
      aliases: ['Offsets'],
      objClass: JitterOffsetsUtils.objectClass,
      objData: ZombieJitterOffsetsData().toJson(),
    );
    final level = PvzLevelFile(objects: [preset]);

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.drive_file_rename_outline));
    await tester.pumpAndSettle();

    expect(
      find.text('Alias (English letters only; no spaces)'),
      findsOneWidget,
    );
    final aliasField = find.byType(TextFormField).last;
    await tester.enterText(aliasField, 'Fast Offsets');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Alias cannot contain spaces'), findsOneWidget);
    expect(preset.aliases?.first, 'Offsets');

    await tester.enterText(aliasField, ' FastOffsets');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Alias cannot contain spaces'), findsOneWidget);
    expect(preset.aliases?.first, 'Offsets');

    await tester.enterText(aliasField, 'Fast　Offsets');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Alias cannot contain spaces'), findsOneWidget);
    expect(preset.aliases?.first, 'Offsets');

    await tester.enterText(aliasField, '偏移预设');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(
      find.text('Alias cannot contain Chinese characters'),
      findsOneWidget,
    );
    expect(preset.aliases?.first, 'Offsets');

    await tester.enterText(
      aliasField,
      'Offsets${String.fromCharCode(0x20000)}',
    );
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(
      find.text('Alias cannot contain Chinese characters'),
      findsOneWidget,
    );
    expect(preset.aliases?.first, 'Offsets');

    await tester.enterText(aliasField, 'Offsets_2');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(preset.aliases?.first, 'Offsets_2');
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects confirmed invalid values but keeps allowed values', (
    tester,
  ) async {
    final preset = PvzObject(
      aliases: ['Offsets'],
      objClass: JitterOffsetsUtils.objectClass,
      objData: ZombieJitterOffsetsData().toJson(),
    );
    final level = PvzLevelFile(objects: [preset]);

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '-1');
    await tester.pump();
    expect(preset.objData, containsPair('ZombieSpawningOffsetIncrement', 80));
    expect(
      find.text(
        'Use a non-negative same-row spawn interval. Negative values may prevent the level from settling normally.',
      ),
      findsOneWidget,
    );

    await tester.enterText(fields.at(1), '0');
    await tester.pump();
    expect(preset.objData, containsPair('ZombieSpawningRandomJitter', 10));
    expect(
      find.text(
        'Use a positive random jitter. A value of 0 causes zombies to be killed immediately before appearing; negative values may prevent the level from settling normally.',
      ),
      findsOneWidget,
    );

    await tester.enterText(fields.at(1), '-3');
    await tester.pump();
    expect(preset.objData, containsPair('ZombieSpawningRandomJitter', 10));
    expect(
      find.text(
        'Use a positive random jitter. A value of 0 causes zombies to be killed immediately before appearing; negative values may prevent the level from settling normally.',
      ),
      findsOneWidget,
    );

    await tester.enterText(fields.at(0), '0');
    await tester.enterText(fields.at(1), '3');
    await tester.pump();
    expect(preset.objData, containsPair('ZombieSpawningOffsetIncrement', 0));
    expect(preset.objData, containsPair('ZombieSpawningRandomJitter', 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows warnings for imported invalid preset values', (
    tester,
  ) async {
    final level = PvzLevelFile(
      objects: [
        PvzObject(
          aliases: ['UnsafeOffsets'],
          objClass: JitterOffsetsUtils.objectClass,
          objData: <String, dynamic>{
            'ZombieSpawningOffsetIncrement': 80,
            'ZombieSpawningRandomJitter': -3,
          },
        ),
      ],
    );

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Use a positive random jitter. A value of 0 causes zombies to be killed immediately before appearing; negative values may prevent the level from settling normally.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('deletes an unreferenced preset after confirmation', (
    tester,
  ) async {
    final preset = PvzObject(
      aliases: ['Offsets'],
      objClass: JitterOffsetsUtils.objectClass,
      objData: ZombieJitterOffsetsData().toJson(),
    );
    final level = PvzLevelFile(objects: [preset]);

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete Preset?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(JitterOffsetsUtils.listPresets(level), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('organizes help into three concise sections', (tester) async {
    final level = PvzLevelFile(objects: []);

    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    final sectionTitles = tester
        .widgetList<Text>(
          find.descendant(of: dialog, matching: find.byType(Text)),
        )
        .map((text) => text.data)
        .whereType<String>()
        .where((text) => text.startsWith('• '))
        .toList();
    expect(sectionTitles, ['• Overview', '• Instructions', '• Parameters']);
    expect(
      find.textContaining('no default preset is provided'),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: dialog,
        matching: find.textContaining(
          'In Basic Spawner and Underwater Spawner events',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: dialog,
        matching: find.textContaining('natural spawn'),
      ),
      findsNothing,
    );
    expect(find.textContaining('A preset can be shared'), findsOneWidget);
    expect(
      find.textContaining('Same-row spawn interval ± Random jitter'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('remains usable on a narrow screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final level = PvzLevelFile(
      objects: [
        PvzObject(
          aliases: ['Offsets'],
          objClass: JitterOffsetsUtils.objectClass,
          objData: ZombieJitterOffsetsData().toJson(),
        ),
      ],
    );
    await tester.pumpWidget(buildScreen(level));
    await tester.pumpAndSettle();

    expect(find.text('Offsets'), findsOneWidget);
    expect(find.text('New Preset'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
