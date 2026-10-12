import 'package:c_editor/data/pvz_alias_utils.dart';
import 'package:c_editor/data/pvz_models.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/widgets/app_message.dart';
import 'package:c_editor/widgets/editor_object_alias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('zh'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: AppMessageMessenger(child: Scaffold(body: child)),
  );
}

void main() {
  tearDown(AppMessage.hide);

  testWidgets('add alias dialog rejects whitespace and Chinese', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showPvzAliasInputDialog(
                context,
                defaultAlias: 'Event1',
                title: 'Add event',
                objClass: 'TestEvent',
                levelFile: PvzLevelFile(objects: []),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final dialogContext = tester.element(find.byType(AlertDialog));
    final l10n = AppLocalizations.of(dialogContext)!;

    await tester.enterText(find.byType(TextField), ' Event1');
    await tester.tap(find.widgetWithText(FilledButton, l10n.add));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(l10n.aliasWhitespaceUnsupported), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(find.byType(TextField), '事件1');
    await tester.tap(find.widgetWithText(FilledButton, l10n.add));
    await tester.pump();
    expect(find.text(l10n.aliasChineseUnsupported), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(find.byType(TextField), 'Event_2');
    await tester.tap(find.widgetWithText(FilledButton, l10n.add));
    await tester.pumpAndSettle();
    expect(result, 'Event_2');
  });

  testWidgets('rename field rejects invalid raw input without changing RTIDs', (
    tester,
  ) async {
    final level = PvzLevelFile(
      objects: [
        PvzObject(aliases: ['Event1'], objClass: 'TestEvent', objData: {}),
        PvzObject(
          aliases: ['Ref'],
          objClass: 'ReferenceHolder',
          objData: {'Event': 'RTID(Event1@CurrentLevel)'},
        ),
      ],
    );
    var alias = 'Event1';

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => EditorAliasInputField(
            alias: alias,
            levelFile: level,
            onAliasChanged: (next) {
              PvzAliasUtils.renameAlias(
                levelFile: level,
                oldAlias: alias,
                newAlias: next,
              );
              setState(() => alias = next);
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Event1\u3000');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(alias, 'Event1');
    expect(level.objects.first.aliases, ['Event1']);
    expect(level.objects.last.objData, {'Event': 'RTID(Event1@CurrentLevel)'});
    expect(AppMessage.controller.message, '代号不支持空格');

    await tester.enterText(find.byType(TextField), '事件2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(alias, 'Event1');
    expect(AppMessage.controller.message, '代号不支持输入中文');

    await tester.enterText(find.byType(TextField), 'Event_2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(AlertDialog)),
    )!;
    await tester.tap(find.widgetWithText(FilledButton, l10n.confirm));
    await tester.pumpAndSettle();

    expect(alias, 'Event_2');
    expect(level.objects.first.aliases, ['Event_2']);
    expect(level.objects.last.objData, {'Event': 'RTID(Event_2@CurrentLevel)'});
  });
}
