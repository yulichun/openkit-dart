import '../../api/LoggerFactory.dart';
import '../../api/Logger.dart';
import '../../api/LogLevel.dart';
import 'ConsoleLogger.dart';

/// Console logger factory implementation
class ConsoleLoggerFactory implements LoggerFactory {
  final LogLevel _defaultLogLevel;

  const ConsoleLoggerFactory(this._defaultLogLevel);

  @override
  Logger createLogger(String name) {
    return createLoggerWithLevel(name, _defaultLogLevel);
  }

  @override
  Logger createLoggerWithLevel(String name, LogLevel level) {
    return ConsoleLogger(name, level);
  }
}
