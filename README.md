# Flutter Namer App — Mobile Development Learning Project

**WeThinkCode_ Mobile Development Elective | 2026**

**Repository Verification Code: `WTC-3SJ3Z8M7`**

## About the Project

This is a Flutter application developed as part of my practical exploration of mobile application development and preparation for the WeThinkCode_ Mobile Development elective.

The project currently implements a simple interactive counter application, demonstrating core Flutter concepts including declarative user interfaces, widgets, local state management, user interactions, and automated widget testing.

The broader learning goal is to extend this foundation into a word-generation application while developing my skills in Dart, Flutter, and cross-platform mobile development.

## Current Features

- Interactive counter that increments when the user presses the floating action button
- Responsive interface built using Flutter Material Design
- Stateful widget management using `StatefulWidget` and `setState()`
- Theme configuration using a seeded Material colour scheme
- Support for Flutter's cross-platform project structure
- Automated widget test verifying that the counter increments correctly

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application framework |
| Dart | Application programming language |
| Material Design | User interface components and styling |
| flutter_test | Automated widget testing |
| Git and GitHub | Version control and project documentation |

The project also declares `english_words` and `provider` dependencies for future development.

## Application Architecture

The current application follows a simple Flutter widget hierarchy:

```text
main()
  |
  v
MyApp (StatelessWidget)
  |
  v
MaterialApp
  |
  v
MyHomePage (StatefulWidget)
  |
  v
_MyHomePageState
  |
  +-- Counter value
  +-- setState()
  +-- Scaffold
       +-- AppBar
       +-- Counter display
       +-- FloatingActionButton
```

### How the Application Works

1. The application starts in `main()` and launches `MyApp`.
2. `MyApp` configures the application theme and home screen.
3. `MyHomePage` manages the counter using a stateful widget.
4. Pressing the floating action button calls `_incrementCounter()`.
5. `setState()` updates the counter and triggers a UI rebuild.
6. The updated counter value appears on the screen.

This demonstrates how Flutter maintains and renders interactive application state.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK (included with Flutter)
- VS Code or Android Studio
- Chrome, an emulator, or a supported physical device

### Clone the Repository

```bash
git clone https://github.com/Boitybanks/flutter-namer-app-wtc.git
cd flutter-namer-app-wtc
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

For a Chrome development session:

```bash
flutter run -d chrome
```

## Quality Assurance and Testing

Run static analysis:

```bash
flutter analyze
```

Run automated widget tests:

```bash
flutter test
```

### Latest Local Validation — 16 October 2026

- `flutter pub get` — Passed
- `flutter analyze` — No issues found
- `flutter test` — All tests passed (1 widget test)

These checks were performed locally before publication.

## Learning Outcomes

Through this project, I practised:

- Understanding Flutter's widget-based architecture
- Working with stateless and stateful widgets
- Managing local application state
- Responding to user interactions
- Using Flutter Material Design components
- Managing dependencies through `pubspec.yaml`
- Writing and running widget tests
- Using Git and GitHub to track development

## Development Roadmap

The following enhancements are planned, not yet implemented:

- [ ] Replace the counter screen with random word-pair generation
- [ ] Introduce application-wide state management with Provider
- [ ] Allow users to save and remove favourite word pairs
- [ ] Add navigation between generator and favourites screens
- [ ] Expand automated widget tests
- [ ] Improve the interface for mobile screen sizes
- [ ] Record an application demonstration video

## WeThinkCode_ Mobile Development Elective

This repository forms part of my practical learning evidence for the **2026 WeThinkCode_ Mobile Development elective**.

**Official repository verification code: `WTC-3SJ3Z8M7`**

I will continue developing the application incrementally, documenting improvements and maintaining meaningful Git commits throughout the elective preparation period.

## Author

**Boitumelo Banks**

Software Engineering Student — WeThinkCode_

GitHub: [Boitybanks](https://github.com/Boitybanks)

---

*Built to practise mobile engineering fundamentals through incremental development, testing, and version control.*