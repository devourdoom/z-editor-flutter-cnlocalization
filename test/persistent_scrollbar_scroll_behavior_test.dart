import 'package:c_editor/widgets/persistent_scrollbar_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app({required TargetPlatform platform, required Widget child}) =>
    MaterialApp(
      theme: ThemeData(platform: platform),
      scrollBehavior: const PersistentScrollbarScrollBehavior(),
      home: Scaffold(body: SizedBox(width: 320, height: 240, child: child)),
    );

ListView _longVerticalList({ScrollController? controller}) => ListView.builder(
  controller: controller,
  itemCount: 30,
  itemBuilder: (_, index) => SizedBox(height: 48, child: Text('Item $index')),
);

Finder get _persistentBar => find.byWidgetPredicate(
  (widget) =>
      widget is Scrollbar &&
      widget.thumbVisibility == true &&
      widget.scrollbarOrientation == ScrollbarOrientation.right,
);

void main() {
  for (final platform in <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.windows,
  ]) {
    testWidgets('vertical pages keep one right scrollbar on ${platform.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(platform: platform, child: _longVerticalList()),
      );
      await tester.pumpAndSettle();

      expect(_persistentBar, findsOneWidget);
      final scrollbar = tester.widget<Scrollbar>(_persistentBar);
      expect(scrollbar.controller, isNotNull);
      expect(scrollbar.trackVisibility, isTrue);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('horizontal controls keep their component-specific behavior', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        platform: TargetPlatform.android,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: const SizedBox(width: 1200, height: 80),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scrollbar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an explicit scrollbar is not duplicated by app behavior', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _app(
        platform: TargetPlatform.android,
        child: Scrollbar(
          key: const ValueKey('explicitScrollbar'),
          controller: controller,
          thumbVisibility: true,
          child: _longVerticalList(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scrollbar), findsOneWidget);
    expect(find.byKey(const ValueKey('explicitScrollbar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested independent vertical regions each keep one scrollbar', (
    tester,
  ) async {
    final outerController = ScrollController();
    final innerController = ScrollController();
    addTearDown(outerController.dispose);
    addTearDown(innerController.dispose);

    await tester.pumpWidget(
      _app(
        platform: TargetPlatform.android,
        child: Scrollbar(
          key: const ValueKey('outerExplicitScrollbar'),
          controller: outerController,
          thumbVisibility: true,
          child: ListView(
            controller: outerController,
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  key: const ValueKey('innerVerticalList'),
                  controller: innerController,
                  itemCount: 20,
                  itemBuilder: (_, index) =>
                      SizedBox(height: 36, child: Text('Nested item $index')),
                ),
              ),
              const SizedBox(height: 500),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scrollbar), findsNWidgets(2));
    expect(
      tester
          .widgetList<Scrollbar>(find.byType(Scrollbar))
          .where((bar) => bar.controller == innerController),
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });
}
