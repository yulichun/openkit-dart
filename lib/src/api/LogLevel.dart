/// Log level for OpenKit
enum LogLevel {
  /// All logs
  all(0),
  
  /// Trace level logs
  trace(1),
  
  /// Debug level logs
  debug(2),
  
  /// Info level logs
  info(3),
  
  /// Warn level logs
  warn(4),
  
  /// Error level logs
  error(5),
  
  /// Fatal level logs
  fatal(6),
  
  /// No logs
  off(7);

  const LogLevel(this.value);
  
  final int value;
  
  /// Get LogLevel from integer value
  static LogLevel fromValue(int value) {
    return LogLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => LogLevel.warn,
    );
  }
}
