import '../protocol/EventType.dart';

/// Static methods for building payload data
class StaticPayloadBuilder {
  /// Build a named event payload
  static String reportNamedEvent(
    String name,
    int actionId,
    int sequenceNumber,
    int timeSinceSessionStart,
  ) {
    return 'et=${EventType.namedEvent.value}&na=${Uri.encodeComponent(name)}&ca=$actionId&sn=$sequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build an event payload with JSON data
  static String sendEvent(String jsonPayload) {
    return 'et=${EventType.event.value}&pl=${Uri.encodeComponent(jsonPayload)}';
  }

  /// Build a crash payload
  static String reportCrash(
    String errorName,
    String reason,
    String stacktrace,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedName = Uri.encodeComponent(errorName);
    final encodedReason = Uri.encodeComponent(reason);
    final encodedStacktrace = Uri.encodeComponent(stacktrace);

    return 'et=${EventType.crash.value}&na=$encodedName&rs=$encodedReason&st=$encodedStacktrace&ca=$startSequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build an error payload
  static String reportError(
    String name,
    int errorValue,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedName = Uri.encodeComponent(name);

    return 'et=${EventType.error.value}&na=$encodedName&ev=$errorValue&ca=$parentActionId&sn=$startSequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build a string value payload
  static String reportValue(
    String name,
    String value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedName = Uri.encodeComponent(name);
    final encodedValue = Uri.encodeComponent(value);

    return 'et=${EventType.valueString.value}&na=$encodedName&vl=$encodedValue&ca=$parentActionId&sn=$startSequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build a double value payload
  static String reportValueDouble(
    String name,
    double value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedName = Uri.encodeComponent(name);

    return 'et=${EventType.valueDouble.value}&na=$encodedName&vl=$value&ca=$parentActionId&sn=$startSequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build an integer value payload
  static String reportValueInt(
    String name,
    int value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedName = Uri.encodeComponent(name);

    return 'et=${EventType.valueDouble.value}&na=$encodedName&vl=$value&ca=$parentActionId&sn=$startSequenceNumber&ts=$timeSinceSessionStart';
  }

  /// Build a session start payload
  static String sessionStart(int sessionId, int timestamp) {
    return 'et=${EventType.sessionStart.value}&si=$sessionId&ts=$timestamp';
  }

  /// Build a session end payload
  static String sessionEnd(int sessionId, int timestamp) {
    return 'et=${EventType.sessionEnd.value}&si=$sessionId&ts=$timestamp';
  }

  /// Build a user identification payload
  static String identifyUser(String userId, int timestamp) {
    final encodedUserId = Uri.encodeComponent(userId);

    return 'et=${EventType.identifyUser.value}&ui=$encodedUserId&ts=$timestamp';
  }

  /// Build a web request payload
  static String webRequest(
    String url,
    int parentActionId,
    int sequenceNumber,
    int timeSinceSessionStart,
  ) {
    final encodedUrl = Uri.encodeComponent(url);

    return 'et=${EventType.webRequest.value}&url=$encodedUrl&ca=$parentActionId&sn=$sequenceNumber&ts=$timeSinceSessionStart';
  }
}
