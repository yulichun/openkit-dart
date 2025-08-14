import '../../api/WebRequestTracer.dart';
import '../config/Configuration.dart';
import 'SessionImpl.dart';

/// Web request tracer implementation
class WebRequestTracerImpl implements WebRequestTracer {
  final Configuration _config;
  final SessionImpl _session;
  final String _url;
  int? _responseCode;
  int? _bytesSent;
  int? _bytesReceived;
  bool _isStarted = false;
  bool _isStopped = false;

  WebRequestTracerImpl(this._config, this._session, this._url);

  @override
  void setResponseCode(int responseCode) {
    if (_isStopped) {
      throw StateError('Cannot set response code on stopped web request tracer');
    }

    _responseCode = responseCode;
    _config.openKit.loggerFactory
        .createLogger('WebRequestTracerImpl')
        .debug('Response code set: $responseCode for URL: $_url');
  }

  @override
  void setBytesSent(int bytesSent) {
    if (_isStopped) {
      throw StateError('Cannot set bytes sent on stopped web request tracer');
    }

    _bytesSent = bytesSent;
    _config.openKit.loggerFactory
        .createLogger('WebRequestTracerImpl')
        .debug('Bytes sent set: $bytesSent for URL: $_url');
  }

  @override
  void setBytesReceived(int bytesReceived) {
    if (_isStopped) {
      throw StateError('Cannot set bytes received on stopped web request tracer');
    }

    _bytesReceived = bytesReceived;
    _config.openKit.loggerFactory
        .createLogger('WebRequestTracerImpl')
        .debug('Bytes received set: $bytesReceived for URL: $_url');
  }

  @override
  void start() {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    _config.openKit.loggerFactory
        .createLogger('WebRequestTracerImpl')
        .debug('Web request started: $_url');
  }

  @override
  void stop() {
    if (_isStopped) {
      return;
    }

    _isStopped = true;
    _config.openKit.loggerFactory
        .createLogger('WebRequestTracerImpl')
        .debug('Web request stopped: $_url (response: $_responseCode, sent: $_bytesSent, received: $_bytesReceived)');
  }

  @override
  bool get isStarted => _isStarted;

  @override
  bool get isStopped => _isStopped;
}
