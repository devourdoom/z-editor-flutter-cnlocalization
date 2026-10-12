import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/events/zombie_fish_wave_event_screen.dart';
import 'package:c_editor/screens/editor/events/zombie_spawn_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic Spawner event binds and unbinds an Offsets preset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final event = PvzObject(
      aliases: ['Wave1'],
      objClass: 'SpawnZombiesJitteredWaveActionProps',
      objData: <String, dynamic>{'Zombies': <dynamic>[]},
    );
    final offsets = PvzObject(
      aliases: ['Offsets'],
      objClass: 'ZombieJitterOffsets',
      objData: <String, dynamic>{
        'ZombieSpawningOffsetIncrement': 20,
        'ZombieSpawningRandomJitter': 10,
      },
    );
    final level = PvzLevelFile(objects: [event, offsets]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ZombieSpawnEventScreen(
          rtid: 'RTID(Wave1@CurrentLevel)',
          levelFile: level,
          onChanged: () {},
          onBack: () {},
          eventSubtitle: '普通出怪',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('出怪间隔偏移'), findsOneWidget);
    expect(find.text('管理预设'), findsOneWidget);
    expect(find.text('不启用（使用游戏内默认参数）'), findsOneWidget);

    final picker = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offsets').last);
    await tester.pumpAndSettle();

    expect(
      (event.objData as Map<String, dynamic>)['JitterOffsets'],
      'RTID(Offsets@CurrentLevel)',
    );

    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('不启用（使用游戏内默认参数）').last);
    await tester.pumpAndSettle();
    expect(
      event.objData as Map<String, dynamic>,
      isNot(contains('JitterOffsets')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('underwater spawn event binds and unbinds an Offsets preset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final event = PvzObject(
      aliases: ['FishWave1'],
      objClass: 'SpawnZombiesFishWaveActionProps',
      objData: <String, dynamic>{'Zombies': <dynamic>[]},
    );
    final offsets = PvzObject(
      aliases: ['Offsets'],
      objClass: 'ZombieJitterOffsets',
      objData: <String, dynamic>{
        'ZombieSpawningOffsetIncrement': 200,
        'ZombieSpawningRandomJitter': 150,
      },
    );
    final level = PvzLevelFile(objects: [event, offsets]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ZombieFishWaveEventScreen(
          rtid: 'RTID(FishWave1@CurrentLevel)',
          levelFile: level,
          onChanged: () {},
          onBack: () {},
          onRequestZombieSelection: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('出怪间隔偏移'), findsOneWidget);
    expect(find.text('管理预设'), findsOneWidget);

    final picker = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offsets').last);
    await tester.pumpAndSettle();

    expect(
      (event.objData as Map<String, dynamic>)['JitterOffsets'],
      'RTID(Offsets@CurrentLevel)',
    );

    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('不启用（使用游戏内默认参数）').last);
    await tester.pumpAndSettle();
    expect(
      event.objData as Map<String, dynamic>,
      isNot(contains('JitterOffsets')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('bound negative-random-jitter preset is invalid in an event', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final event = PvzObject(
      aliases: ['Wave1'],
      objClass: 'SpawnZombiesJitteredWaveActionProps',
      objData: <String, dynamic>{
        'JitterOffsets': 'RTID(UnsafeOffsets@CurrentLevel)',
        'Zombies': <dynamic>[],
      },
    );
    final offsets = PvzObject(
      aliases: ['UnsafeOffsets'],
      objClass: 'ZombieJitterOffsets',
      objData: <String, dynamic>{
        'ZombieSpawningOffsetIncrement': 80,
        'ZombieSpawningRandomJitter': -1,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ZombieSpawnEventScreen(
          rtid: 'RTID(Wave1@CurrentLevel)',
          levelFile: PvzLevelFile(objects: [event, offsets]),
          onChanged: () {},
          onBack: () {},
          eventSubtitle: '普通出怪',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('UnsafeOffsets（参数无效）'), findsOneWidget);
    expect(
      find.text('当前预设包含无效参数。请在「管理预设」中将「同一行出怪间隔」改为非负数，并将「浮动范围」改为正数。'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
