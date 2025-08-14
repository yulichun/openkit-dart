import '../../api/StatusRequest.dart';

/// Implementation of StatusRequest
class StatusRequestImpl implements StatusRequest {
  final String _applicationId;
  final int _serverId;
  final int _timestamp;
  final String? _deviceId;
  final String? _sessionId;

  StatusRequestImpl._({
    required String applicationId,
    required int serverId,
    required int timestamp,
    String? deviceId,
    String? sessionId,
  })  : _applicationId = applicationId,
        _serverId = serverId,
        _timestamp = timestamp,
        _deviceId = deviceId,
        _sessionId = sessionId;

  /// Create a basic status request
  static StatusRequestImpl create(
    String applicationId,
    int serverId,
    int timestamp,
  ) {
    return StatusRequestImpl._(
      applicationId: applicationId,
      serverId: serverId,
      timestamp: timestamp,
    );
  }

  /// Create a new session request
  static StatusRequestImpl createNewSession(
    String applicationId,
    int serverId,
    int timestamp,
    String deviceId,
    String sessionId,
  ) {
    return StatusRequestImpl._(
      applicationId: applicationId,
      serverId: serverId,
      timestamp: timestamp,
      deviceId: deviceId,
      sessionId: sessionId,
    );
  }

  @override
  String get applicationId => _applicationId;

  @override
  int get serverId => _serverId;

  @override
  int get timestamp => _timestamp;

  @override
  String? get deviceId => _deviceId;

  @override
  String? get sessionId => _sessionId;

  /// Convert to query string
  String toQueryString() {
    final params = <String>[
      'aid=$_applicationId',
      'sid=$_serverId',
      'ts=$_timestamp',
    ];

    if (_deviceId != null) {
      params.add('did=$_deviceId');
    }

    if (_sessionId != null) {
      params.add('ssid=$_sessionId');
    }

    return params.join('&');
  }
}
