import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/main.dart';

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(440, 950);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MyApp());
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Generator shows controls and generates another word pair', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.byKey(const Key('generated-name')), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    await tapVisible(tester, find.byKey(const Key('next-name')));
    expect(find.byKey(const Key('generated-name')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Can save, view, remove and undo removal of a favorite', (
    tester,
  ) async {
    await openApp(tester);
    await tapVisible(tester, find.byKey(const Key('toggle-favorite')));
    expect(find.text('Unlike'), findsOneWidget);
    await tapVisible(tester, find.text('Favorites'));
    expect(find.text('1 idea worth keeping'), findsOneWidget);
    await tapVisible(tester, find.byIcon(Icons.delete_outline));
    expect(find.text('No favorites yet.'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('1 idea worth keeping'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets(
    'Unlike removes the current pair and empty state returns to generator',
    (tester) async {
      await openApp(tester);
      await tapVisible(tester, find.byKey(const Key('toggle-favorite')));
      expect(find.text('Unlike'), findsOneWidget);
      await tapVisible(tester, find.byKey(const Key('toggle-favorite')));
      expect(find.text('Like'), findsOneWidget);
      await tapVisible(tester, find.text('Favorites'));
      expect(find.text('No favorites yet.'), findsOneWidget);
      await tapVisible(tester, find.text('Find your first idea'));
      expect(find.byKey(const Key('next-name')), findsOneWidget);
    },
  );

  testWidgets('Copy writes the current name only on request', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await openApp(tester);
    expect(copied, isNull);
    final name = tester
        .widget<Text>(find.byKey(const Key('generated-name')))
        .textSpan!
        .toPlainText()
        .replaceAll('\n', '');
    await tapVisible(tester, find.byKey(const Key('copy-name')));
    expect(copied, name);
    expect(find.text('Name copied. Go make something.'), findsOneWidget);
  });

  for (final size in [const Size(320, 568), const Size(1440, 1000)]) {
    testWidgets('Navigation and actions work at $size with large text', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const MyApp());
      await tapVisible(tester, find.byKey(const Key('next-name')));
      await tapVisible(tester, find.byKey(const Key('toggle-favorite')));
      await tapVisible(tester, find.text('Favorites'));
      await tapVisible(tester, find.byIcon(Icons.delete_outline));
      expect(find.text('No favorites yet.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
