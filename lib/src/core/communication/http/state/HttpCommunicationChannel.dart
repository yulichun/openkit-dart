import '../../../../api/CommunicationChannel.dart';
import '../../../../api/StatusRequest.dart';
import '../../../../api/StatusResponse.dart';
import '../../../../api/LoggerFactory.dart';
import '../../../../api/Logger.dart';
import '../FetchHttpClient.dart';
import '../StatusResponseImpl.dart';

/// HTTP communication channel implementation
class HttpCommunicationChannel implements CommunicationChannel {
  final FetchHttpClient _httpClient;
  final LoggerFactory _loggerFactory;
  late final Logger _logger;
  bool _isAvailable = true;

  HttpCommunicationChannel(this._httpClient, this._loggerFactory) {
    _logger = _loggerFactory.createLogger('HttpCommunicationChannel');
  }

  @override
  Future<StatusResponse> sendStatusRequest(
      String url, StatusRequest request) async {
    try {
      _logger.debug('Sending status request to: $url');

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body:
            'aid=${request.applicationId}&sid=${request.serverId}&ts=${request.timestamp}${request.deviceId != null ? '&did=${request.deviceId}' : ''}${request.sessionId != null ? '&ssid=${request.sessionId}' : ''}',
      );

      final statusResponse = StatusResponseImpl(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      _logger.debug('Received status response: ${response.statusCode}');
      return statusResponse;
    } catch (e) {
      _logger.error('Error sending status request: $e');
      rethrow;
    }
  }

  @override
  Future<StatusResponse> sendNewSessionRequest(
      String url, StatusRequest request) async {
    return sendStatusRequest(url, request);
  }

  @override
  Future<StatusResponse> sendPayloadData(
      String url, StatusRequest request, String payload) async {
    try {
      _logger.debug('Sending payload data to: $url');

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body:
            'aid=${request.applicationId}&sid=${request.serverId}&ts=${request.timestamp}${request.deviceId != null ? '&did=${request.deviceId}' : ''}${request.sessionId != null ? '&ssid=${request.sessionId}' : ''}&$payload',
      );

      final statusResponse = StatusResponseImpl(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      _logger.debug('Received payload response: ${response.statusCode}');
      return statusResponse;
    } catch (e) {
      _logger.error('Error sending payload data: $e');
      rethrow;
    }
  }

  @override
  bool isAvailable() {
    return _isAvailable;
  }

  @override
  Future<void> initialize() async {
    _logger.info('Initializing HTTP communication channel');
    _isAvailable = true;
  }

  @override
  Future<void> close() async {
    _logger.info('Closing HTTP communication channel');
    _isAvailable = false;
  }
}
