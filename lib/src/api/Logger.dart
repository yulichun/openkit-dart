import 'LogLevel.dart';

/// Interface for logging
abstract class Logger {
  /// Log a message at trace level
  void trace(String message);

  /// Log a message at debug level
  void debug(String message);

  /// Log a message at info level
  void info(String message);

  /// Log a message at warn level
  void warn(String message);

  /// Log a warning message (alias for warn)
  void warning(String message) => warn(message);

  /// Log a message at error level
  void error(String message);

  /// Log a message at fatal level
  void fatal(String message);

  /// Check if a log level is enabled
  bool isEnabled(LogLevel level);
}
