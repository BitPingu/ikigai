# Ikigai

A self-help productivity app that uses gamification and RPG-inspired progression to make building habits and accomplishing goals more motivating.

## Features

- Quest creation and management
- Daily quest progress tracking
- EXP rewards for completing quests

## Tech Stack

| Technology | Description |
|---|---|
| [Flutter](https://flutter.dev/) | Cross-platform UI framework |
| [Dart](https://dart.dev/) | Application programming language |
| [Riverpod](https://riverpod.dev/) | State management |
| [GoRouter](https://pub.dev/packages/go_router) | Declarative navigation |
| [fl_chart](https://pub.dev/packages/fl_chart) | Data visualization |

## Project Structure

```text
lib/
├── models/       # Application data models
├── providers/    # State management
├── router/       # Navigation configuration
├── screens/      # Application screens
├── theme/        # Application themes and styling
└── widgets/      # Reusable UI components
```

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.50.0
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/BitPingu/ikigai.git
   cd ikigai
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the application:

   ```bash
   flutter run
   ```

## Scripts

| Command | Description |
|---|---|
| `flutter run` | Runs the application |
| `dart format .` | Formats Dart source files |
| `dart format --set-exit-if-changed .` | Checks Dart formatting |
| `flutter analyze` | Runs static analysis |
| `flutter test` | Executes automated tests |
