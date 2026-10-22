# Flutter Namer App — WeThinkCode_ Mobile Development Elective

**Repository verification code:** `WTC-3SJ3Z8M7`

This repository follows the [Flutter first app codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#0), building a responsive random word-pair generator with Material 3, Provider and ChangeNotifier.

## Features
- Generate random English word pairs with **Next**
- Like/unlike the current suggestion
- Browse saved favorites and remove them
- Adaptive navigation: bottom bar on narrow screens, navigation rail on wider screens
- Widget tests for generation, favorite management, and the Like/Unlike flow
- Unit tests for state changes and ChangeNotifier listener notifications

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

## Evidence status — 22 October 2026
The project is committed to `main`, with GitHub Actions configured to run `flutter analyze` and `flutter test` on each push. An earlier CI run reported a widget-test failure; navigation selection was corrected and an additional Like/Unlike regression test was added. **The latest CI result and live UI behavior have not yet been verified.** Do not mark validation complete until a run succeeds.

### Code snapshot
- `lib/main.dart` — Material 3 app, Provider state, generator and favorites pages
- `test/widget_test.dart` — generator, save/remove, and Like/Unlike user journeys
- `test/app_state_test.dart` — state transitions and listener notifications
- `.github/workflows/flutter.yml` — automated static analysis and widget tests

### Evidence to capture
1. Generator screen showing a word pair and Like/Next controls.
2. Favorites screen showing a saved word pair and its remove button.
3. GitHub Actions green check for both static analysis and widget tests.
4. A narrated 5–10 minute demonstration explaining the code and interactions.

The application follows the Flutter codelab; the tests and documentation are subsequent improvements. Firebase Authentication is a separate elective deliverable and is **not implemented in this repository**.

### Proof checklist
- [x] Word-pair generator and favorites implementation
- [x] Responsive navigation
- [x] Widget and state unit tests written
- [ ] Static analysis and tests executed successfully
- [ ] Screenshots of generator and favorites screens
- [ ] 5–10 minute narrated demonstration recorded
- [ ] Final elective evidence submitted by 30 October 2026

## Author
Boitumelo Banks — WeThinkCode_ Software Engineering
