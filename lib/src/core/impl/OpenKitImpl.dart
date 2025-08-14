import '../../api/OpenKit.dart';
import '../../api/Session.dart';
import '../config/Configuration.dart';
import '../api/SessionImpl.dart';

/// OpenKit implementation
class OpenKitImpl implements OpenKit {
  final Configuration _config;
  bool _isInitialized = false;
  bool _isShutdown = false;
  final List<SessionImpl> _sessions = [];

  OpenKitImpl(this._config);

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await _config.openKit.communicationChannel.initialize();
      _isInitialized = true;
      _config.openKit.loggerFactory
          .createLogger('OpenKitImpl')
          .info('OpenKit initialized successfully');
    } catch (e) {
      _config.openKit.loggerFactory
          .createLogger('OpenKitImpl')
          .error('Failed to initialize OpenKit: $e');
      rethrow;
    }
  }

  @override
  Session createSession(String clientIPAddress) {
    if (!_isInitialized) {
      throw StateError('OpenKit must be initialized before creating sessions');
    }

    final session = SessionImpl(
      _config,
      clientIPAddress,
      null,
    );
    _sessions.add(session);
    return session;
  }

  @override
  Session createSessionWithUserId(String clientIPAddress, String userId) {
    if (!_isInitialized) {
      throw StateError('OpenKit must be initialized before creating sessions');
    }

    final session = SessionImpl(
      _config,
      clientIPAddress,
      userId,
    );
    _sessions.add(session);
    return session;
  }

  @override
  Future<void> shutdown() async {
    if (_isShutdown) {
      return;
    }

    try {
      // End all active sessions
      for (final session in _sessions) {
        if (!session.isEnded) {
          session.end();
        }
      }

      await _config.openKit.communicationChannel.close();
      _isShutdown = true;
      _config.openKit.loggerFactory
          .createLogger('OpenKitImpl')
          .info('OpenKit shutdown successfully');
    } catch (e) {
      _config.openKit.loggerFactory
          .createLogger('OpenKitImpl')
          .error('Failed to shutdown OpenKit: $e');
      rethrow;
    }
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isShutdown => _isShutdown;
}
