import 'package:c_editor/bloc/settings/settings_cubit.dart';
import 'package:c_editor/data/interface_menu_config.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/screens/interface_settings_screen.dart';
import 'package:c_editor/widgets/app_ui_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SettingsCubit settings;
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'locale': 'en',
      'theme_mode': 'light',
      'ui_scale': 1.0,
    });
    preferences = await SharedPreferences.getInstance();
    settings = SettingsCubit(preferences);
  });

  tearDown(() async {
    await settings.close();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    Size size = const Size(1000, 1400),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BlocProvider.value(
        value: settings,
        child: AppUiScale(
          scale: 1,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const InterfaceSettingsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder previewTransform(AppLocalizations l10n) {
    return find
        .ancestor(
          of: find.text(l10n.uiScalePreviewTitle),
          matching: find.byType(Transform),
        )
        .first;
  }

  testWidgets('shows the four settings areas and a live draft scale preview', (
    tester,
  ) async {
    await pumpScreen(tester);
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(find.text(l10n.language), findsWidgets);
    expect(find.text(l10n.toggleTheme), findsWidgets);
    expect(find.text(l10n.uiSize), findsWidgets);
    expect(find.text(l10n.autosave), findsWidgets);
    expect(find.text(l10n.menuCustomization), findsOneWidget);

    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.thumbVisibility, isTrue);
    expect(scrollbar.scrollbarOrientation, ScrollbarOrientation.right);

    await tester.tap(find.text(l10n.languageChinese));
    await tester.pump();
    expect(settings.state.locale, const Locale('zh'));
    expect(preferences.getString('locale'), 'zh');

    await tester.tap(find.text(l10n.darkTheme));
    await tester.pump();
    expect(settings.state.themeMode, ThemeMode.dark);
    expect(preferences.getString('theme_mode'), 'dark');

    final autosave = find.byKey(
      const ValueKey('interfaceSettingsAutosave_level'),
    );
    await tester.ensureVisible(autosave);
    await tester.tap(autosave);
    await tester.pump();
    expect(settings.state.autosaveTargets, contains(AutosaveTarget.level));
    expect(preferences.getBool(AutosaveTarget.level.preferenceKey), isTrue);

    final slider = find.byKey(const ValueKey('interfaceSettingsUiScaleSlider'));
    await tester.ensureVisible(slider);
    final initialPreviewScale = tester
        .widget<Transform>(previewTransform(l10n))
        .transform
        .getMaxScaleOnAxis();
    final gesture = await tester.startGesture(tester.getCenter(slider));
    await gesture.moveBy(const Offset(160, 0));
    await tester.pump();
    final draftPreviewScale = tester
        .widget<Transform>(previewTransform(l10n))
        .transform
        .getMaxScaleOnAxis();
    expect(draftPreviewScale, greaterThan(initialPreviewScale));
    expect(settings.state.uiScale, 1.0, reason: 'dragging only changes draft');

    await gesture.up();
    await tester.pump();
    expect(settings.state.uiScale, greaterThan(1.0));
    expect(preferences.getDouble('ui_scale'), settings.state.uiScale);
    expect(tester.takeException(), isNull);
  });

  testWidgets('customizes all three top-right action surfaces independently', (
    tester,
  ) async {
    await pumpScreen(tester);
    final l10n = lookupAppLocalizations(const Locale('en'));
    final customization = find.text(l10n.menuCustomization);
    await tester.ensureVisible(customization);
    await tester.pumpAndSettle();

    expect(find.text(l10n.menuSurfaceWorkspace), findsOneWidget);
    expect(find.text(l10n.menuSurfaceLevelEditor), findsOneWidget);
    expect(find.text(l10n.menuSurfaceJsonViewer), findsOneWidget);
    expect(
      find.byKey(const ValueKey('interfaceMenu_workspace')),
      findsOneWidget,
    );

    final workspaceList = tester.widget<ReorderableListView>(
      find.byKey(const ValueKey('interfaceMenu_workspace')),
    );
    workspaceList.onReorderItem!(0, 1);
    await tester.pump();
    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.workspace)
          .first
          .id,
      InterfaceMenuActionIds.theme,
    );

    final workspaceLanguage = find.byKey(const ValueKey('workspace_lang'));
    await tester.ensureVisible(workspaceLanguage);
    await tester.tap(
      find.descendant(
        of: workspaceLanguage,
        matching: find.text(l10n.menuPlacementOverflow),
      ),
    );
    await tester.pump();
    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.workspace)
          .singleWhere((action) => action.id == InterfaceMenuActionIds.language)
          .placement,
      InterfaceMenuPlacement.overflow,
    );

    await tester.ensureVisible(find.text(l10n.menuSurfaceLevelEditor));
    await tester.tap(find.text(l10n.menuSurfaceLevelEditor));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('interfaceMenu_levelEditor')),
      findsOneWidget,
    );
    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.levelEditor)
          .singleWhere((action) => action.id == InterfaceMenuActionIds.language)
          .placement,
      InterfaceMenuPlacement.toolbar,
      reason: 'the workspace placement must not leak into the editor',
    );
    final editorAutosave = find.byKey(const ValueKey('levelEditor_autosave'));
    await tester.ensureVisible(editorAutosave);
    await tester.tap(
      find.descendant(
        of: editorAutosave,
        matching: find.text(l10n.menuPlacementToolbar),
      ),
    );
    await tester.pump();
    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.levelEditor)
          .singleWhere((action) => action.id == InterfaceMenuActionIds.autosave)
          .placement,
      InterfaceMenuPlacement.toolbar,
    );

    await tester.ensureVisible(find.text(l10n.menuSurfaceJsonViewer));
    await tester.tap(find.text(l10n.menuSurfaceJsonViewer));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('interfaceMenu_jsonViewer')),
      findsOneWidget,
    );
    final jsonEdit = find.byKey(const ValueKey('jsonViewer_edit'));
    await tester.ensureVisible(jsonEdit);
    await tester.tap(
      find.descendant(
        of: jsonEdit,
        matching: find.text(l10n.menuPlacementToolbar),
      ),
    );
    await tester.pump();
    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.jsonViewer)
          .singleWhere((action) => action.id == InterfaceMenuActionIds.editJson)
          .placement,
      InterfaceMenuPlacement.toolbar,
    );

    expect(
      settings.state
          .interfaceMenuActionsFor(InterfaceMenuSurface.workspace)
          .singleWhere((action) => action.id == InterfaceMenuActionIds.autosave)
          .placement,
      InterfaceMenuPlacement.overflow,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('restores scroll offset in memory without persisting it', (
    tester,
  ) async {
    await pumpScreen(tester, size: const Size(800, 640));
    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView).first,
    );
    final controller = scrollView.controller!;
    controller.jumpTo(0);
    await tester.pump();
    controller.jumpTo(500);
    await tester.pump();
    final rememberedOffset = controller.offset;
    expect(rememberedOffset, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(
      preferences.getKeys().where((key) => key.contains('scroll')),
      isEmpty,
    );

    await pumpScreen(tester, size: const Size(800, 640));
    final restored = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView).first,
    );
    expect(restored.controller!.offset, closeTo(rememberedOffset, 0.1));
    expect(tester.takeException(), isNull);
  });
}
