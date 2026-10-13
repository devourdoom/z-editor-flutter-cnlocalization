import 'package:c_editor/data/jitter_offsets_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/editor/events/zombie_fish_wave_event_screen.dart';
import 'package:c_editor/screens/editor/events/zombie_spawn_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ground Spawner model preserves JitterOffsets and FixedOffset', () {
    final restored = SpawnZombiesFromGroundData.fromJson(<String, dynamic>{
      'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
      'FixedOffset': 24.5,
      'ColumnStart': 2,
      'ColumnEnd': 7,
      'Zombies': <dynamic>[],
    });

    expect(restored.jitterOffsets, 'RTID(Offsets@CurrentLevel)');
    expect(restored.fixedOffset, 24.5);
    expect(restored.toJson(), containsPair('FixedOffset', 24.5));
    expect(
      restored.toJson(),
      containsPair('JitterOffsets', 'RTID(Offsets@CurrentLevel)'),
    );
  });

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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ZombieSpawnEventScreen)),
    )!;
    expect(find.text('出怪位置偏移'), findsOneWidget);
    expect(find.text('管理预设'), findsOneWidget);
    expect(find.text('不绑定（使用游戏内默认参数 80 / 30）'), findsOneWidget);
    expect(find.text(l10n.jitterOffsetsEventDescription), findsOneWidget);
    final sectionIcon = tester.widget<Icon>(find.byIcon(Icons.speed));
    expect(
      sectionIcon.color,
      Theme.of(tester.element(find.byIcon(Icons.speed))).colorScheme.secondary,
    );
    expect(
      tester.widget<Text>(find.text('出怪位置偏移')).style?.color,
      Theme.of(tester.element(find.text('出怪位置偏移'))).colorScheme.onSurface,
    );

    final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();
    final pickerScrollbar = tester.widget<Scrollbar>(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(Scrollbar),
      ),
    );
    expect(pickerScrollbar.thumbVisibility, isTrue);
    expect(pickerScrollbar.trackVisibility, isTrue);
    final noneOption = tester.widget<Text>(
      find.text('不绑定（使用游戏内默认参数 80 / 30）').last,
    );
    expect(noneOption.maxLines, isNull);
    expect(noneOption.overflow, isNull);
    await tester.tap(find.text('Offsets').last);
    await tester.pumpAndSettle();

    expect(
      (event.objData as Map<String, dynamic>)['JitterOffsets'],
      'RTID(Offsets@CurrentLevel)',
    );

    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('不绑定（使用游戏内默认参数 80 / 30）').last);
    await tester.pumpAndSettle();
    expect(
      event.objData as Map<String, dynamic>,
      isNot(contains('JitterOffsets')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('event keeps the functional hint when no preset exists', (
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

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ZombieSpawnEventScreen(
          rtid: 'RTID(Wave1@CurrentLevel)',
          levelFile: PvzLevelFile(objects: [event]),
          onChanged: () {},
          onBack: () {},
          eventSubtitle: '普通出怪',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ZombieSpawnEventScreen)),
    )!;
    expect(find.text(l10n.jitterOffsetsEventDescription), findsOneWidget);
    expect(find.textContaining('还没有预设'), findsNothing);
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

    expect(find.text('出怪位置偏移'), findsOneWidget);
    expect(find.text('管理预设'), findsOneWidget);

    final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
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
    await tester.tap(find.text('不绑定（使用游戏内默认参数 80 / 30）').last);
    await tester.pumpAndSettle();
    expect(
      event.objData as Map<String, dynamic>,
      isNot(contains('JitterOffsets')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Ground Spawner retains offsets while FixedOffset temporarily overrides them',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final event = PvzObject(
        aliases: ['GroundWave1'],
        objClass: 'SpawnZombiesFromGroundSpawnerProps',
        objData: <String, dynamic>{
          'JitterOffsets': 'RTID(Offsets@CurrentLevel)',
          'ZombieSpawnPattern': 'RTID(Pattern@CurrentLevel)',
          'FixedOffset': 32,
          'ColumnStart': 2,
          'ColumnEnd': 7,
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
          home: ZombieSpawnEventScreen(
            rtid: 'RTID(GroundWave1@CurrentLevel)',
            levelFile: level,
            onChanged: () {},
            onBack: () {},
            eventSubtitle: '地底出怪',
            isGroundSpawner: true,
            onRequestZombieSelection: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
      expect(picker, findsOneWidget);
      expect(find.textContaining('按整批僵尸的创建顺序追加固定偏移'), findsOneWidget);
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
      final fixedOffsetField = find.byKey(const ValueKey('fixedOffsetField'));
      await tester.ensureVisible(fixedOffsetField);
      await tester.enterText(fixedOffsetField, '0');
      await tester.pumpAndSettle();

      expect(
        event.objData as Map<String, dynamic>,
        containsPair('JitterOffsets', 'RTID(Offsets@CurrentLevel)'),
      );
      expect(
        event.objData as Map<String, dynamic>,
        containsPair('ZombieSpawnPattern', 'RTID(Pattern@CurrentLevel)'),
      );
      expect(
        event.objData as Map<String, dynamic>,
        isNot(contains('FixedOffset')),
      );

      await tester.ensureVisible(picker);
      await tester.tap(picker);
      await tester.pumpAndSettle();
      await tester.tap(find.text('不绑定（使用游戏内默认参数 80 / 30）').last);
      await tester.pumpAndSettle();
      expect(
        event.objData as Map<String, dynamic>,
        isNot(contains('JitterOffsets')),
      );
      expect(
        event.objData as Map<String, dynamic>,
        containsPair('ZombieSpawnPattern', 'RTID(Pattern@CurrentLevel)'),
      );
      expect(tester.takeException(), isNull);
    },
  );

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
    expect(find.text('当前预设包含无效参数。请在「管理预设」中将「随机偏移上限」改为正数。'), findsOneWidget);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ZombieSpawnEventScreen)),
    )!;
    expect(find.text(l10n.jitterOffsetsEventDescription), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting a local preset replaces an external same-name RTID', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final event = PvzObject(
      aliases: ['WaveExternal'],
      objClass: 'SpawnZombiesJitteredWaveActionProps',
      objData: <String, dynamic>{
        'JitterOffsets': 'RTID(Offsets@ExternalPackage)',
        'Zombies': <dynamic>[],
      },
    );
    final offsets = PvzObject(
      aliases: ['Offsets'],
      objClass: JitterOffsetsUtils.objectClass,
      objData: ZombieJitterOffsetsData().toJson(),
    );
    final level = PvzLevelFile(objects: [event, offsets]);

    expect(JitterOffsetsUtils.findReferrers(level, 'Offsets'), isEmpty);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ZombieSpawnEventScreen(
          rtid: 'RTID(WaveExternal@CurrentLevel)',
          levelFile: level,
          onChanged: () {},
          onBack: () {},
          eventSubtitle: 'Basic Spawner',
          isGroundSpawner: false,
          onRequestZombieSelection: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Offsets (missing)'), findsWidgets);
    final picker = find.byKey(const ValueKey('jitterOffsetsPresetPicker'));
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offsets'));
    await tester.pumpAndSettle();

    expect(
      event.objData as Map<String, dynamic>,
      containsPair('JitterOffsets', 'RTID(Offsets@CurrentLevel)'),
    );
    expect(JitterOffsetsUtils.findReferrers(level, 'Offsets'), [event]);
    expect(tester.takeException(), isNull);
  });
}
