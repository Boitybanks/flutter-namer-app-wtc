import 'package:english_words/english_words.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/main.dart';

void main() {
  group('MyAppState', () {
    test('starts with no favorites', () {
      final state = MyAppState();
      expect(state.favorites, isEmpty);
      state.dispose();
    });

    test('toggling a favorite adds and removes the current pair', () {
      final state = MyAppState();
      final pair = state.current;

      state.toggleFavorite();
      expect(state.favorites, contains(pair));

      state.toggleFavorite();
      expect(state.favorites, isNot(contains(pair)));
      state.dispose();
    });

    test('changing the current pair notifies listeners', () {
      final state = MyAppState();
      var notifications = 0;
      state.addListener(() => notifications++);

      state.getNext();

      expect(notifications, 1);
      state.dispose();
    });

    test('removing a saved pair notifies listeners', () {
      final state = MyAppState();
      final pair = WordPair('bright', 'river');
      state.favorites.add(pair);
      var notifications = 0;
      state.addListener(() => notifications++);

      state.removeFavorite(pair);

      expect(state.favorites, isNot(contains(pair)));
      expect(notifications, 1);
      state.dispose();
    });
  });
}
