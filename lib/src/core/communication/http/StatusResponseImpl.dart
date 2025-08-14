import '../../../api/StatusResponse.dart';
import '../../../api/CaptureMode.dart';

/// Status response implementation
class StatusResponseImpl implements StatusResponse {
  @override
  final int statusCode;

  @override
  final Map<String, String> headers;

  @override
  final String? body;

  const StatusResponseImpl({
    required this.statusCode,
    required this.headers,
    this.body,
  });

  @override
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  @override
  CaptureMode? get captureMode => null;

  @override
  int? get serverId => null;

  @override
  int? get maxBeaconSizeInKb => null;

  @override
  CaptureMode? get captureErrors => null;

  @override
  CaptureMode? get captureCrashes => null;

  @override
  int? get multiplicity => null;

  @override
  int? get trafficControlPercentage => null;

  @override
  String? get applicationId => null;

  @override
  int? get timestamp => null;

  @override
  bool get isValid => isSuccessful;
}
