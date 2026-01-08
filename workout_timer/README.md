# Workout Timer

A cross-platform workout timer app built with Flutter, supporting nested workout sets with flexible time and rep-based exercises.

## Features

- Cross-platform support (iOS, Android, Windows, macOS, Linux)
- JSON-based workout definitions with nested sets
- Support for both time-based and rep-based exercises
- Circuit training with configurable rounds
- Rest periods between rounds
- Screen wake lock to prevent sleep during workouts
- Estimated workout duration calculation

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── workout.dart         # Workout data model
│   └── workout_set.dart     # Set data model
├── screens/
│   └── home_screen.dart     # Main screen showing workout details
└── widgets/
    └── workout_card.dart    # Reusable widget for displaying sets

assets/
└── workouts/
    └── example.json         # Example workout definition
```

## Data Model

Workouts are defined in JSON format with the following structure:

### Workout
- `name` (string, required): Name of the workout
- `description` (string, optional): Description of the workout
- `sets` (array, required): Array of set objects

### Set
Sets can be either **leaf sets** (with type/value) or **container sets** (with nested sets):

**Leaf Set:**
- `name` (string, required): Name of the exercise
- `description` (string, optional): Description
- `type` (enum, required): Either "reps" or "time"
- `value` (number, required): Number of reps or seconds

**Container Set:**
- `name` (string, required): Name of the set (e.g., "Main Circuit")
- `description` (string, optional): Description
- `sets` (array, required): Nested array of sets
- `rounds` (integer, optional): Number of times to repeat (default: 1)
- `restBetweenRounds` (number, optional): Rest time in seconds between rounds

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart 3.10 or higher

### Installation

1. Clone the repository:
```bash
cd workout_timer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Run on connected device/emulator
flutter run

# Or run on specific platform
flutter run -d chrome        # Web
flutter run -d macos          # macOS
flutter run -d linux          # Linux
flutter run -d windows        # Windows
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build macos --release
flutter build linux --release
flutter build windows --release
```

## Dependencies

- `provider: ^6.1.1` - State management
- `wakelock_plus: ^1.2.0` - Prevent screen sleep during workouts
- `audioplayers: ^6.1.0` - Audio cues for workout transitions

## Example Workout

See `assets/workouts/example.json` for a complete example of a HIIT workout with:
- Warm-up section
- Main circuit with 3 rounds
- Supersets with rest periods
- Cool-down stretches

## Next Steps

- [ ] Implement workout timer screen with countdown
- [ ] Add audio/visual cues for exercise transitions
- [ ] Create workout library management
- [ ] Add ability to create/edit workouts in-app
- [ ] Implement workout history tracking
- [ ] Add statistics and progress tracking
- [ ] Support for custom audio cues (beeps, voice)
- [ ] Import/export workouts

## License

MIT
