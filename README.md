# Water Tracker App

A Flutter application that helps you track your daily water intake and sends reminders to stay hydrated.

## Features

- **Daily Water Tracking**: Track your water intake with customizable daily goals
- **Visual Progress**: Circular progress indicator showing your daily progress
- **Quick Add Buttons**: One-tap buttons for common water amounts (250mL, 500mL, 1L)
- **Custom Amount Input**: Add any custom amount of water
- **Smart Reminders**: Configurable reminder system with start/end times and intervals
- **Data Persistence**: All data is saved locally and persists between app sessions
- **Daily Auto-Reset**: Intake automatically resets at midnight
- **Settings Customization**: Adjust daily goals, reminder settings, and more

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extension
- Android device or emulator

### Installation

1. Clone or download the project
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect an Android device or start an emulator
5. Run `flutter run` to launch the app

### Building for Release

To build an APK for distribution:

```bash
flutter build apk --release
```

## Usage

### Tracking Water Intake

1. Open the app to see your daily progress
2. Use the quick buttons to add common amounts
3. Or use the custom input field for specific amounts
4. Your progress is automatically saved

### Setting Up Reminders

1. Go to Settings from the home screen
2. Enable reminders if not already enabled
3. Set your preferred reminder interval (default: 2 hours)
4. Configure start and end times for reminder periods
5. Save your settings

### Customizing Goals

1. Navigate to Settings
2. Adjust your daily water goal (default: 2000mL)
3. Save the new goal

## Technical Details

### Architecture

- **Provider Pattern**: State management using Provider
- **Local Storage**: Shared Preferences for data persistence
- **Notifications**: Flutter Local Notifications for reminders
- **Material Design**: Modern Flutter UI components

### Dependencies

- `shared_preferences`: Local data storage
- `flutter_local_notifications`: Push notifications
- `percent_indicator`: Progress visualization
- `provider`: State management
- `intl`: Internationalization support

### File Structure

```
lib/
├── main.dart                 # App entry point
├── providers/
│   └── water_tracker_provider.dart  # State management
├── screens/
│   ├── home_screen.dart     # Main tracking interface
│   └── settings_screen.dart # Settings and configuration
└── services/
    └── notification_service.dart # Notification handling
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.