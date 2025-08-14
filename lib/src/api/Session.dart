import 'Action.dart';
import 'WebRequestTracer.dart';
import 'Json.dart';
import 'ConnectionType.dart';

/// Interface for OpenKit session
abstract class Session {
  /// Enter an action with the specified name
  Action enterAction(String actionName);

  /// Identify user with the specified user ID
  void identifyUser(String userId);

  /// Reports an error with a specified name and error code to Dynatrace.
  /// If the message is longer than 1000 characters, it is truncated to this value.
  void reportError(String name, int code);

  /// Report a crash to Dynatrace.
  /// If the stacktrace is longer than 128.000 characters, it is truncated according to the last line break.
  /// If the message is longer than 1000 characters, it is truncated to this value.
  void reportCrash(String name, String message, String stacktrace);

  /// Trace a web request
  WebRequestTracer traceWebRequest(String url);

  /// Send a Business Event
  /// With sendBizEvent, you can report a business event. These standalone events are being sent detached
  /// from user actions or sessions.
  /// Note: The 'dt' key, as well as all 'dt.' prefixed keys are considered reserved by Dynatrace
  /// and will be stripped from the passed in attributes.
  /// Note: Business events are only supported on Dynatrace SaaS deployments currently.
  void sendBizEvent(String type, Json attributes);

  /// Reports the network technology in use (e.g. 2G, 3G, 802.11x, offline, ...)
  /// Use null to clear the value again and it will not be sent.
  void reportNetworkTechnology(String? technology);

  /// Reports the type of connection with which the device is connected to the network.
  /// Use null to clear the value again and it will not be sent.
  void reportConnectionType(ConnectionType? connectionType);

  /// Reports the name of the cellular network carrier.
  /// The given value will be truncated to 250 characters.
  /// Use null to clear the value again and it will not be sent.
  void reportCarrier(String? carrier);

  /// End the session
  void end();

  /// Check if the session is ended
  bool get isEnded;

  /// Get the session ID
  String get sessionId;
}
