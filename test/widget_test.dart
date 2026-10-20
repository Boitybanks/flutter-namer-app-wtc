import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/main.dart';

void main() {
  testWidgets('Generator shows controls and generates another word pair', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('A random idea:'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('A random idea:'), findsOneWidget);
  });

  testWidgets('Can save, view and remove a favorite', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Like'));
    await tester.pump();
    expect(find.text('Unlike'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pumpAndSettle();
    expect(find.text('You have 1 favorite:'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();
    expect(find.text('No favorites yet.'), findsOneWidget);
  });
}
