import '../../api/Logger.dart';
import '../../api/LogLevel.dart';

/// Console logger implementation
class ConsoleLogger implements Logger {
  final String _name;
  final LogLevel _level;

  const ConsoleLogger(this._name, this._level);

  @override
  void trace(String message) {
    if (isEnabled(LogLevel.trace)) {
      print('[$_name] TRACE: $message');
    }
  }

  @override
  void debug(String message) {
    if (isEnabled(LogLevel.debug)) {
      print('[$_name] DEBUG: $message');
    }
  }

  @override
  void info(String message) {
    if (isEnabled(LogLevel.info)) {
      print('[$_name] INFO: $message');
    }
  }

  @override
  void warn(String message) {
    if (isEnabled(LogLevel.warn)) {
      print('[$_name] WARN: $message');
    }
  }

  @override
  void warning(String message) => warn(message);

  @override
  void error(String message) {
    if (isEnabled(LogLevel.error)) {
      print('[$_name] ERROR: $message');
    }
  }

  @override
  void fatal(String message) {
    if (isEnabled(LogLevel.fatal)) {
      print('[$_name] FATAL: $message');
    }
  }

  @override
  bool isEnabled(LogLevel level) {
    return level.value >= _level.value;
  }
}
