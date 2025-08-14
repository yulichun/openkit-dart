import 'Logger.dart';
import 'LogLevel.dart';

/// Interface for creating logger instances
abstract class LoggerFactory {
  /// Create a logger with the specified name
  Logger createLogger(String name);
  
  /// Create a logger with the specified name and log level
  Logger createLoggerWithLevel(String name, LogLevel level);
}
