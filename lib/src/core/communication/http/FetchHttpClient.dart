import 'package:http/http.dart' as http;
import '../../../api/LoggerFactory.dart';
import '../../../api/Logger.dart';

/// HTTP client implementation using the http package
class FetchHttpClient {
  final LoggerFactory _loggerFactory;
  late final Logger _logger;

  FetchHttpClient(this._loggerFactory) {
    _logger = _loggerFactory.createLogger('FetchHttpClient');
  }

  /// Send a GET request
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      _logger.debug('Sending GET request to: $url');
      final response = await http.get(Uri.parse(url), headers: headers);
      _logger.debug('Received response: ${response.statusCode}');
      return response;
    } catch (e) {
      _logger.error('Error sending GET request: $e');
      rethrow;
    }
  }

  /// Send a POST request
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      _logger.debug('Sending POST request to: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      _logger.debug('Received response: ${response.statusCode}');
      return response;
    } catch (e) {
      _logger.error('Error sending POST request: $e');
      rethrow;
    }
  }
}
