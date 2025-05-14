# EmoSense AI: Emotion Recognition for Customer Service

EmoSense AI is a Flutter application designed to detect and analyze emotions in customer service interactions. The app provides real-time emotion detection, historical data analysis, and AI-powered recommendations to improve customer service quality.

![EmoSense AI Logo](assets/app_icon.svg)

## Features

- **Real-time Emotion Detection**: Analyze customer emotions during live conversations
- **Dashboard Analytics**: Visualize emotion data with intuitive charts and gauges
- **Video Analysis**: Process recorded videos to extract emotional insights
- **Session History**: Review past interactions with detailed emotional timelines
- **AI Recommendations**: Get actionable suggestions based on detected emotions
- **Dark/Light Mode**: Fully customizable theme with smooth transitions
- **Modern UI**: Material 3 design with animations and responsive layouts

## Screenshots

![EmoSense AI Screenshot](screenshots/home_screen.png)

## Technologies Used

- Flutter for cross-platform mobile development
- Provider package for state management
- Material 3 design components
- Custom animations and transitions
- Responsive UI for various screen sizes

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.17 or higher)
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/emosense.git
   ```

2. Navigate to the project directory:
   ```
   cd emosense
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart` - Main application entry point and theme configuration
- `lib/screens/` - UI screens for different app sections
- `lib/components/` - Reusable UI components
- `lib/models/` - Data models for the application
- `lib/services/` - Business logic and API services

## Future Enhancements

- Integration with real-time audio processing APIs
- Machine learning model for more accurate emotion detection
- Cloud synchronization for team collaboration
- Advanced analytics and reporting features

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by advancements in emotion AI and customer experience management
- Built with Flutter and Material Design principles

## Project Structure

### Import Guidelines

This project uses a centralized import approach to simplify importing widgets and packages across the app.

#### Core Imports

For UI components and Flutter packages, import the core.dart file:

```dart
import '../core/core.dart';
```

This will give you access to:
- Flutter Material package
- Flutter Services package
- Provider package
- All custom widgets organized by category

#### Models

Models should be imported directly:

```dart
import '../models/analytics_data.dart';
```

#### Providers

Providers should be imported directly:

```dart
import '../presentation/providers/theme_provider.dart';
```

### Folder Structure

The project follows a clean architecture approach:

- **lib/core**: Core components of the application
  - **widgets/**: All reusable widgets organized by feature
  - **models/**: Data models 
  - **utils/**: Utility functions and helpers

- **lib/presentation**: UI layer 
  - **providers/**: State management providers
  - **pages/**: Full screen pages

- **lib/screens**: Screen implementations

- **lib/services**: Business logic and services

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application
