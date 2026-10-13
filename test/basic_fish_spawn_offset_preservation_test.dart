import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/events/zombie_fish_wave_event_screen.dart';
import 'package:c_editor/screens/editor/events/zombie_spawn_event_screen.dart';
import 'package:c_editor/widgets/editor_components.dart';
import 'package:c_editor/widgets/jitter_offsets_binding_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('zombie entry-side mapping follows the game facing direction', () {
    expect(ZombieSpawnData.entersFromLeft('right'), isTrue);
    expect(ZombieSpawnData.entersFromLeft('left'), isFalse);
    expect(ZombieSpawnData.entersFromLeft(null), isFalse);
    expect(ZombieSpawnData.directionForEntrySide(true), 'right');
    expect(ZombieSpawnData.directionForEntrySide(false), isNull);
  });

  testWidgets(
    'FixedOffset editor defaults to zero and rejects non-finite input',
    (tester) async {
      num? changed;
      await _pumpEditor(
        tester,
        Scaffold(
          body: FixedOffsetAdvancedSettingsCard(
            value: null,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey('fixedOffsetAdvancedSettings')),
      );
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('fixedOffsetField'));
      expect(tester.widget<TextFormField>(field).initialValue, '0');

      await tester.enterText(field, 'NaN');
      await tester.pump();
      expect(changed, isNull);
      expect(find.text('请输入有效的数字。'), findsOneWidget);

      await tester.enterText(field, 'Infinity');
      await tester.pump();
      expect(changed, isNull);

      await tester.enterText(field, '-12.5');
      await tester.pump();
      expect(changed, -12.5);
    },
  );

  test('basic and underwater models preserve all position controls', () {
    const source = <String, dynamic>{
      'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
      'ZombieSpawnPattern': 'ZombieSpawnerPatternStaggered',
      'FixedOffset': 24.5,
      'Zombies': <dynamic>[],
    };

    final basic = WaveActionData.fromJson(source);
    final underwater = SpawnZombiesFishWaveActionPropsData.fromJson(source);

    for (final restored in <Map<String, dynamic>>[
      basic.toJson(),
      underwater.toJson(),
    ]) {
      expect(restored['JitterOffsets'], 'RTID(Offsets@CurrentLevel)');
      expect(restored['ZombieSpawnPattern'], 'ZombieSpawnerPatternStaggered');
      expect(restored['FixedOffset'], 24.5);
    }
  });

  testWidgets(
    'basic spawner exposes event-local FixedOffset and restores its preset at zero',
    (tester) async {
      final event = _event(
        alias: 'Wave1',
        objClass: 'SpawnZombiesJitteredWaveActionProps',
      );
      final level = PvzLevelFile(objects: [event, _offsetsPreset()]);

      await _pumpEditor(
        tester,
        ZombieSpawnEventScreen(
          rtid: 'RTID(Wave1@CurrentLevel)',
          levelFile: level,
          onChanged: () {},
          onBack: () {},
          eventSubtitle: 'Basic Spawner',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      );

      await _expectOverrideThenRestore(tester, event);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'underwater spawner exposes event-local FixedOffset and restores its preset at zero',
    (tester) async {
      final event = _event(
        alias: 'FishWave1',
        objClass: 'SpawnZombiesFishWaveActionProps',
      );
      final level = PvzLevelFile(objects: [event, _offsetsPreset()]);

      await _pumpEditor(
        tester,
        ZombieFishWaveEventScreen(
          rtid: 'RTID(FishWave1@CurrentLevel)',
          levelFile: level,
          onChanged: () {},
          onBack: () {},
          onRequestZombieSelection: (_) {},
        ),
      );

      await _expectOverrideThenRestore(tester, event);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'underwater direction switch maps entry side and unrelated edits preserve it',
    (tester) async {
      final event = PvzObject(
        aliases: ['FishDirection'],
        objClass: 'SpawnZombiesFishWaveActionProps',
        objData: <String, dynamic>{
          'Zombies': <dynamic>[
            <String, dynamic>{
              'Type': 'RTID(zombie@ZombieTypes)',
              'Level': 1,
              'Row': 1,
              'Direction': 'right',
              'Titles': <String>['ZTSpeed1'],
            },
          ],
        },
      );

      await _pumpEditor(
        tester,
        ZombieFishWaveEventScreen(
          rtid: 'RTID(FishDirection@CurrentLevel)',
          levelFile: PvzLevelFile(objects: [event]),
          onChanged: () {},
          onBack: () {},
          onRequestZombieSelection: (_) {},
        ),
      );

      final zombieCard = find.byType(ZombieIconCard);
      await tester.ensureVisible(zombieCard);
      await tester.tap(zombieCard);
      await tester.pumpAndSettle();

      final directionTile = find.widgetWithText(SwitchListTile, '从场地左侧出现');
      expect(tester.widget<SwitchListTile>(directionTile).value, isTrue);

      final rowField = find.byType(DropdownButtonFormField<int>);
      await tester.tap(rowField);
      await tester.pumpAndSettle();
      await tester.tap(find.text('第2行').last);
      await tester.pumpAndSettle();
      _expectFishZombieFields(event, direction: 'right', row: 2);

      await tester.tap(directionTile);
      await tester.pumpAndSettle();
      _expectFishZombieFields(event, direction: null, row: 2);

      await tester.tap(directionTile);
      await tester.pumpAndSettle();
      _expectFishZombieFields(event, direction: 'right', row: 2);

      Navigator.of(tester.element(directionTile)).pop();
      await tester.pumpAndSettle();
      final applyButton = find.widgetWithText(FilledButton, '一键应用');
      await tester.ensureVisible(applyButton);
      await tester.tap(applyButton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '一键应用').last);
      await tester.pumpAndSettle();
      _expectFishZombieFields(event, direction: 'right', row: 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'basic spawner keeps editing the same zombie after a row reorder',
    (tester) async {
      final event = PvzObject(
        aliases: ['BasicDirection'],
        objClass: 'SpawnZombiesJitteredWaveActionProps',
        objData: <String, dynamic>{
          'Zombies': <dynamic>[
            <String, dynamic>{
              'Type': 'RTID(zombie@ZombieTypes)',
              'Level': 1,
              'Row': 1,
              'Direction': 'right',
              'Titles': <String>['ZTSpeed1'],
            },
            <String, dynamic>{
              'Type': 'RTID(conehead@ZombieTypes)',
              'Level': 2,
              'Row': 2,
              'Direction': 'left',
            },
          ],
        },
      );

      await _pumpEditor(
        tester,
        ZombieSpawnEventScreen(
          rtid: 'RTID(BasicDirection@CurrentLevel)',
          levelFile: PvzLevelFile(objects: [event]),
          onChanged: () {},
          onBack: () {},
          eventSubtitle: 'Basic Spawner',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      );

      final zombieCards = find.byType(ZombieIconCard);
      await tester.ensureVisible(zombieCards.first);
      await tester.tap(zombieCards.first);
      await tester.pumpAndSettle();

      final rowField = find.byType(DropdownButtonFormField<int>);
      await tester.tap(rowField);
      await tester.pumpAndSettle();
      await tester.tap(find.text('第3行').last);
      await tester.pumpAndSettle();

      final directionTile = find.widgetWithText(SwitchListTile, '从场地左侧出现');
      expect(tester.widget<SwitchListTile>(directionTile).value, isTrue);
      await tester.tap(directionTile);
      await tester.pumpAndSettle();

      final zombies =
          ((event.objData as Map<String, dynamic>)['Zombies'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      final edited = zombies.singleWhere(
        (entry) => entry['Type'] == 'RTID(zombie@ZombieTypes)',
      );
      final untouched = zombies.singleWhere(
        (entry) => entry['Type'] == 'RTID(conehead@ZombieTypes)',
      );
      expect(edited['Row'], 3);
      expect(edited, isNot(contains('Direction')));
      expect(edited['Titles'], <String>['ZTSpeed1']);
      expect(untouched['Row'], 2);
      expect(untouched['Direction'], 'left');
      expect(tester.takeException(), isNull);
    },
  );
}

void _expectFishZombieFields(
  PvzObject event, {
  required String? direction,
  required int row,
}) {
  final data = event.objData as Map<String, dynamic>;
  final zombie =
      (data['Zombies'] as List<dynamic>).single as Map<String, dynamic>;
  expect(zombie['Row'], row);
  if (direction == null) {
    expect(zombie, isNot(contains('Direction')));
  } else {
    expect(zombie['Direction'], direction);
  }
  expect(zombie['Titles'], <String>['ZTSpeed1']);
}

PvzObject _event({required String alias, required String objClass}) {
  return PvzObject(
    aliases: [alias],
    objClass: objClass,
    objData: <String, dynamic>{
      'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
      'ZombieSpawnPattern': 'ZombieSpawnerPatternStaggered',
      'FixedOffset': 32,
      'Zombies': <dynamic>[],
    },
  );
}

PvzObject _offsetsPreset() {
  return PvzObject(
    aliases: ['Offsets'],
    objClass: 'ZombieJitterOffsets',
    objData: <String, dynamic>{
      'ZombieSpawningOffsetIncrement': 80,
      'ZombieSpawningRandomJitter': 30,
    },
  );
}

Future<void> _pumpEditor(WidgetTester tester, Widget home) async {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('zh'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _expectOverrideThenRestore(
  WidgetTester tester,
  PvzObject event,
) async {
  final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
  await tester.ensureVisible(picker);
  await tester.tap(picker);
  await tester.pumpAndSettle();
  expect(find.text('Offsets'), findsOneWidget);

  final advanced = find.byKey(const ValueKey('fixedOffsetAdvancedSettings'));
  await tester.ensureVisible(advanced);
  await tester.tap(advanced);
  await tester.pumpAndSettle();
  expect(find.text('全局序号固定偏移 (FixedOffset)'), findsOneWidget);

  final field = find.byKey(const ValueKey('fixedOffsetField'));
  await tester.ensureVisible(field);
  await tester.enterText(field, '0');
  await tester.pumpAndSettle();

  final json = event.objData as Map<String, dynamic>;
  expect(json['JitterOffsets'], 'RTID(Offsets@CurrentLevel)');
  expect(json['ZombieSpawnPattern'], 'ZombieSpawnerPatternStaggered');
  expect(json, isNot(contains('FixedOffset')));

  await tester.ensureVisible(picker);
  await tester.tap(picker);
  await tester.pumpAndSettle();
  expect(find.text('Offsets'), findsWidgets);
  await tester.tap(find.text('Offsets').last);
  await tester.pumpAndSettle();
}
