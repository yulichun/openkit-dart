/// Interface for status request to Dynatrace
abstract class StatusRequest {
  /// Get the application ID
  String get applicationId;

  /// Get the server ID
  int get serverId;

  /// Get the timestamp
  int get timestamp;

  /// Get the device ID (optional)
  String? get deviceId;

  /// Get the session ID (optional)
  String? get sessionId;
}
