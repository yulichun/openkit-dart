import 'CaptureMode.dart';

/// Interface for status response from Dynatrace
abstract class StatusResponse {
  /// If captureMode = Off, all communication should be stopped and no further communication is allowed.
  CaptureMode? get captureMode;

  /// The server id where the next request should be send to.
  int? get serverId;

  /// The maximum beacon size in kilobyte.
  int? get maxBeaconSizeInKb;

  /// Flag if errors should be captured.
  CaptureMode? get captureErrors;

  /// Flag if crashes should be captured.
  CaptureMode? get captureCrashes;

  /// The multiplicity which should be send back to the server.
  int? get multiplicity;

  /// Traffic control percentage.
  int? get trafficControlPercentage;

  /// The application which this configuration applies to.
  String? get applicationId;

  /// Timestamp of the configuration
  int? get timestamp;

  /// Flag if the response is valid. If it is not, all communication stops immediately for the current session.
  bool get isValid;
}
