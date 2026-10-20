# Flutter Namer App — WeThinkCode_ Mobile Development Elective

**Repository verification code:** `WTC-3SJ3Z8M7`

This repository follows the [Flutter first app codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#0), building a responsive random word-pair generator with Material 3, Provider and ChangeNotifier.

## Features
- Generate random English word pairs with **Next**
- Like/unlike the current suggestion
- Browse saved favorites and remove them
- Adaptive navigation: bottom bar on narrow screens, navigation rail on wider screens
- Widget tests for generation and favorite management

## Learning concepts
- Stateless and stateful widgets; widget composition
- `ChangeNotifier`, `ChangeNotifierProvider`, `context.watch` and `notifyListeners`
- Declarative UI updates and Material 3
- Responsive layouts with `LayoutBuilder`
- Widget tests with `flutter_test`

## Run and verify
```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Architecture
`main()` → `MyApp` → `ChangeNotifierProvider<MyAppState>` → `MyHomePage` → `GeneratorPage` / `FavoritesPage`.

`MyAppState` owns the current `WordPair` and the in-memory favorites list. Favorites are not persisted between restarts.

## Evidence status — 20 October 2026
Code and widget tests have been updated remotely on an elective development branch. **Flutter analyze, flutter test and live UI verification have not yet been executed in this remote session.** Run the commands above or use a Flutter-capable CI runner before marking validation complete.

### Proof checklist
- [x] Word-pair generator and favorites implementation
- [x] Responsive navigation
- [x] Widget tests written
- [ ] Static analysis and tests executed successfully
- [ ] Screenshots of generator and favorites screens
- [ ] 5–10 minute narrated demonstration recorded
- [ ] Final elective evidence submitted by 30 October 2026

## Author
Boitumelo Banks — WeThinkCode_ Software Engineering
