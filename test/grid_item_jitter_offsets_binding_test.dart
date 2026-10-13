import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/events/grid_item_spawn_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('grid-item spawn data round-trips jitter and fixed offsets', () {
    final data = SpawnZombiesFromGridItemData.fromJson(<String, dynamic>{
      'WaveStartMessage': 'READY',
      'ZombieSpawnWaitTime': 3,
      'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
      'FixedOffset': 24.5,
      'GridTypes': <String>['RTID(gravestone@GridItemTypes)'],
      'Zombies': <dynamic>[],
    });

    expect(data.jitterOffsets, 'RTID(Offsets@CurrentLevel)');
    expect(data.fixedOffset, 24.5);
    expect(data.toJson(), <String, dynamic>{
      'WaveStartMessage': 'READY',
      'ZombieSpawnWaitTime': 3,
      'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
      'FixedOffset': 24.5,
      'GridTypes': <String>['RTID(gravestone@GridItemTypes)'],
      'Zombies': <dynamic>[],
    });

    final withoutJitter = data.copyWith(clearJitterOffsets: true);
    expect(withoutJitter.jitterOffsets, isNull);
    expect(withoutJitter.fixedOffset, 24.5);
    expect(withoutJitter.toJson(), isNot(contains('JitterOffsets')));
  });

  testWidgets(
    'obstacle spawner disables its preset while FixedOffset overrides it',
    (tester) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final event = PvzObject(
        aliases: ['GridSpawn1'],
        objClass: 'SpawnZombiesFromGridItemSpawnerProps',
        objData: <String, dynamic>{
          'ZombieSpawnWaitTime': 0,
          'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
          'ZombieSpawnPattern': 'RTID(Pattern@CurrentLevel)',
          'FixedOffset': 40,
          'GridTypes': <String>[],
          'Zombies': <dynamic>[],
        },
      );
      final offsets = PvzObject(
        aliases: ['Offsets'],
        objClass: 'ZombieJitterOffsets',
        objData: <String, dynamic>{
          'ZombieSpawningOffsetIncrement': 80,
          'ZombieSpawningRandomJitter': 30,
        },
      );
      final level = PvzLevelFile(objects: [event, offsets]);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GridItemSpawnEventScreen(
            rtid: 'RTID(GridSpawn1@CurrentLevel)',
            levelFile: level,
            onChanged: () {},
            onBack: () {},
            onRequestGridItemSelection: (_) {},
            onRequestZombieSelection: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('出怪位置偏移'), findsOneWidget);
      expect(find.textContaining('按整批僵尸的创建顺序追加固定偏移'), findsOneWidget);

      final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
      await tester.ensureVisible(picker);
      await tester.tap(picker);
      await tester.pumpAndSettle();
      expect(find.text('Offsets'), findsOneWidget);

      final advanced = find.byKey(
        const ValueKey('fixedOffsetAdvancedSettings'),
      );
      await tester.ensureVisible(advanced);
      await tester.tap(advanced);
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('fixedOffsetField'));
      await tester.ensureVisible(field);
      await tester.enterText(field, '0');
      await tester.pumpAndSettle();

      expect(event.objData, isA<Map<String, dynamic>>());
      final boundJson = event.objData as Map<String, dynamic>;
      expect(boundJson['JitterOffsets'], 'RTID(Offsets@CurrentLevel)');
      expect(boundJson['ZombieSpawnPattern'], 'RTID(Pattern@CurrentLevel)');
      expect(boundJson, isNot(contains('FixedOffset')));
      expect(JitterOffsetsUtils.findReferrers(level, 'Offsets'), [event]);

      await tester.ensureVisible(picker);
      await tester.tap(picker);
      await tester.pumpAndSettle();
      expect(find.text('Offsets'), findsWidgets);
      await tester.tap(find.text('Offsets').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
