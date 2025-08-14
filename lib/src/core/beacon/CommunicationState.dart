import '../../api/StatusResponse.dart';
import '../../api/CaptureMode.dart';

/// Represents the state of the current OpenKit Object.
abstract class CommunicationState {
  /// The server id which should be used for the next request.
  int get serverId;

  /// The maximum beacon size in bytes.
  int get maxBeaconSize;

  /// The multiplicity which should be send to the server.
  int get multiplicity;

  /// Flag to check if errors should be captured.
  CaptureMode get captureErrors;

  /// The crash reporting mode
  CaptureMode get captureCrashes;

  /// General capture mode
  CaptureMode get capture;

  /// Traffic control percentage.
  int get trafficControlPercentage;

  /// Timestamp of the current configuration
  int get timestamp;

  /// Locks the server id so it can't change.
  void setServerIdLocked();

  /// Update the state with a status response.
  void updateFromResponse(StatusResponse response);

  /// Disables all capturing of data.
  void disableCapture();

  /// Set server ID
  void setServerId(int id);
}
