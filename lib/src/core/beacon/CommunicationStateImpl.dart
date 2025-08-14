import '../../api/StatusResponse.dart';
import '../../api/CaptureMode.dart';
import 'CommunicationState.dart';

/// Implementation of CommunicationState
class CommunicationStateImpl implements CommunicationState {
  int _serverId;
  int _maxBeaconSize;
  int _multiplicity;
  CaptureMode _captureErrors;
  CaptureMode _captureCrashes;
  CaptureMode _capture;
  int _trafficControlPercentage;
  int _timestamp;
  bool _serverIdLocked = false;

  CommunicationStateImpl({
    int serverId = 1,
    int maxBeaconSize = 30,
    int multiplicity = 1,
    CaptureMode captureErrors = CaptureMode.on,
    CaptureMode captureCrashes = CaptureMode.on,
    CaptureMode capture = CaptureMode.on,
    int trafficControlPercentage = 100,
    int timestamp = 0,
  })  : _serverId = serverId,
        _maxBeaconSize = maxBeaconSize,
        _multiplicity = multiplicity,
        _captureErrors = captureErrors,
        _captureCrashes = captureCrashes,
        _capture = capture,
        _trafficControlPercentage = trafficControlPercentage,
        _timestamp = timestamp;

  @override
  int get serverId => _serverId;

  @override
  int get maxBeaconSize => _maxBeaconSize;

  @override
  int get multiplicity => _multiplicity;

  @override
  CaptureMode get captureErrors => _captureErrors;

  @override
  CaptureMode get captureCrashes => _captureCrashes;

  @override
  CaptureMode get capture => _capture;

  @override
  int get trafficControlPercentage => _trafficControlPercentage;

  @override
  int get timestamp => _timestamp;

  @override
  void setServerIdLocked() {
    _serverIdLocked = true;
  }

  @override
  void updateFromResponse(StatusResponse response) {
    if (response.captureMode != null) {
      _capture = response.captureMode!;
    }
    if (response.serverId != null && !_serverIdLocked) {
      _serverId = response.serverId!;
    }
    if (response.maxBeaconSizeInKb != null) {
      _maxBeaconSize = response.maxBeaconSizeInKb!;
    }
    if (response.captureErrors != null) {
      _captureErrors = response.captureErrors!;
    }
    if (response.captureCrashes != null) {
      _captureCrashes = response.captureCrashes!;
    }
    if (response.multiplicity != null) {
      _multiplicity = response.multiplicity!;
    }
    if (response.trafficControlPercentage != null) {
      _trafficControlPercentage = response.trafficControlPercentage!;
    }
    if (response.timestamp != null) {
      _timestamp = response.timestamp!;
    }
  }

  @override
  void disableCapture() {
    _capture = CaptureMode.off;
    _captureErrors = CaptureMode.off;
    _captureCrashes = CaptureMode.off;
  }

  @override
  void setServerId(int id) {
    if (!_serverIdLocked) {
      _serverId = id;
    }
  }
}
