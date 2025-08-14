import '../../api/Session.dart';
import '../../api/Action.dart';
import '../../api/WebRequestTracer.dart';
import '../../api/Json.dart';
import '../../api/ConnectionType.dart';
import '../config/Configuration.dart';
import '../beacon/CommunicationStateImpl.dart';
import '../beacon/SupplementaryBasicDataImpl.dart';
import '../payload/PayloadBuilder.dart';
import 'ActionImpl.dart';
import 'WebRequestTracerImpl.dart';

/// Session implementation
class SessionImpl implements Session {
  final Configuration _config;
  final String _clientIPAddress;
  final String? _userId;
  final String _sessionId;
  bool _isEnded = false;
  final List<ActionImpl> _actions = [];
  final CommunicationStateImpl _commState;
  final PayloadBuilder _payloadBuilder;

  SessionImpl(this._config, this._clientIPAddress, this._userId)
      : _sessionId = _generateSessionId(),
        _commState = CommunicationStateImpl(),
        _payloadBuilder = PayloadBuilder(
          CommunicationStateImpl(),
          SupplementaryBasicDataImpl(_config),
          100,
        );

  static String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '${timestamp}_$random';
  }

  @override
  Action enterAction(String actionName) {
    if (_isEnded) {
      throw StateError('Cannot enter action on ended session');
    }

    final action = ActionImpl(_config, this, actionName);
    _actions.add(action);
    return action;
  }

  @override
  void identifyUser(String userId) {
    if (_isEnded) {
      throw StateError('Cannot identify user on ended session');
    }

    // In a real implementation, this would update the session's user identification
    _config.openKit.loggerFactory
        .createLogger('SessionImpl')
        .info('User identified: $userId');
  }

  @override
  WebRequestTracer traceWebRequest(String url) {
    if (_isEnded) {
      throw StateError('Cannot trace web request on ended session');
    }

    return WebRequestTracerImpl(_config, this, url);
  }

  @override
  void reportError(String name, int code) {
    if (_isEnded) {
      throw StateError('Cannot report error on ended session');
    }

    _config.openKit.loggerFactory
        .createLogger('SessionImpl')
        .info('Error reported: $name (code: $code)');
  }

  @override
  void reportCrash(String name, String message, String stacktrace) {
    if (_isEnded) {
      throw StateError('Cannot report crash on ended session');
    }

    _config.openKit.loggerFactory
        .createLogger('SessionImpl')
        .info('Crash reported: $name - $message');
  }

  @override
  void sendBizEvent(String type, Json attributes) {
    if (_isEnded) {
      throw StateError('Cannot send business event on ended session');
    }

    _config.openKit.loggerFactory
        .createLogger('SessionImpl')
        .info('Business event sent: $type');
  }

  @override
  void reportNetworkTechnology(String? technology) {
    if (_isEnded) {
      throw StateError('Cannot report network technology on ended session');
    }

    if (technology != null) {
      _config.openKit.loggerFactory
          .createLogger('SessionImpl')
          .info('Network technology reported: $technology');
    }
  }

  @override
  void reportConnectionType(ConnectionType? connectionType) {
    if (_isEnded) {
      throw StateError('Cannot report connection type on ended session');
    }

    if (connectionType != null) {
      _config.openKit.loggerFactory
          .createLogger('SessionImpl')
          .info('Connection type reported: ${connectionType.value}');
    }
  }

  @override
  void reportCarrier(String? carrier) {
    if (_isEnded) {
      throw StateError('Cannot report carrier on ended session');
    }

    if (carrier != null) {
      final truncatedCarrier =
          carrier.length > 250 ? carrier.substring(0, 250) : carrier;
      _config.openKit.loggerFactory
          .createLogger('SessionImpl')
          .info('Carrier reported: $truncatedCarrier');
    }
  }

  @override
  void end() {
    if (_isEnded) {
      return;
    }

    // End all active actions
    for (final action in _actions) {
      if (!action.isEnded) {
        action.end();
      }
    }

    _isEnded = true;
    _config.openKit.loggerFactory
        .createLogger('SessionImpl')
        .info('Session ended: $_sessionId');
  }

  @override
  bool get isEnded => _isEnded;

  @override
  String get sessionId => _sessionId;
}
