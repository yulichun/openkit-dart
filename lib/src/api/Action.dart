/// Interface for OpenKit action
abstract class Action {
  /// Report an event with the specified name
  void reportEvent(String eventName);

  /// Report a value with the specified name and value
  void reportValue(String valueName, String value);

  /// Report a value with the specified name and double value
  void reportValueDouble(String valueName, double value);

  /// Report a value with the specified name and integer value
  void reportValueInt(String valueName, int value);

  /// Report an error with the specified name, code and reason
  void reportError(String errorName, int errorCode, String reason);

  /// End the action
  void end();

  /// Check if the action is ended
  bool get isEnded;

  /// Get the action ID
  String get actionId;
}
