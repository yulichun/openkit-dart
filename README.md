# OpenKit-Dart

OpenKit-Dart is a reference implementation of Dynatrace OpenKit for Dart and Flutter applications. It provides Real User Monitoring (RUM) capabilities for tracking user interactions, performance metrics, and application behavior.

## Features

- **Real User Monitoring (RUM)**: Track user sessions, actions, and web requests
- **Performance Monitoring**: Monitor application performance and response times
- **Crash Reporting**: Optional crash reporting with configurable levels
- **Data Collection Control**: Configurable data collection levels for privacy compliance
- **Cross-Platform Support**: Works on Flutter (iOS, Android, Web, Desktop)
- **Flexible Configuration**: Builder pattern for easy configuration

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  openkit_dart: ^1.0.0
```

## Quick Start

### Basic Usage

```dart
import 'package:openkit_dart/openkit_dart.dart';

void main() async {
  // Create OpenKit instance
  final openKit = OpenKitBuilder(
    'https://your-dynatrace-environment.com/mbeacon',
    'your-application-id',
    12345, // device ID
  )
    .withOperatingSystem('Flutter')
    .withApplicationVersion('1.0.0')
    .withLogLevel(LogLevel.info)
    .build();

  // Create a session
  final session = openKit.createSession('192.168.1.1');

  // Enter an action
  final action = session.enterAction('User Login');
  
  // Report events and values
  action.reportEvent('Login Attempted');
  action.reportValue('username', 'john.doe');
  
  // End the action
  action.end();

  // End the session
  session.end();

  // Shutdown OpenKit
  await openKit.shutdown();
}
```

### Advanced Configuration

```dart
final openKit = OpenKitBuilder(
  'https://your-dynatrace-environment.com/mbeacon',
  'your-application-id',
  12345,
)
  .withOperatingSystem('Flutter')
  .withApplicationVersion('1.0.0')
  .withDataCollectionLevel(DataCollectionLevel.performance)
  .withCrashReportingLevel(CrashReportingLevel.optInCrashes)
  .withManufacturer('Apple')
  .withModelId('iPhone 14')
  .withUserLanguage('en-US')
  .withScreenResolution(390, 844)
  .withScreenOrientation(Orientation.portrait)
  .withLogLevel(LogLevel.debug)
  .build();
```

## API Reference

### Core Classes

- **OpenKitBuilder**: Main builder class for configuring and creating OpenKit instances
- **OpenKit**: Main interface for OpenKit functionality
- **Session**: Represents a user session
- **Action**: Represents user actions within a session
- **WebRequestTracer**: Tracks web requests and their performance

### Configuration Options

- **Data Collection Level**: Control the amount of data collected
- **Crash Reporting Level**: Configure crash reporting behavior
- **Operating System**: Set the target operating system
- **Device Information**: Configure device-specific settings
- **Logging**: Set log levels and custom logger factories

## Data Collection Levels

- **Off (0)**: No data collected
- **Performance (1)**: Only performance-related data
- **UserBehavior (2)**: All available RUM data including performance

## Crash Reporting Levels

- **Off (0)**: No crashes reported
- **OptOutCrashes (1)**: No crashes reported (opt-out)
- **OptInCrashes (2)**: Crashes are reported (opt-in)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions, please refer to the Dynatrace documentation or create an issue in this repository.
