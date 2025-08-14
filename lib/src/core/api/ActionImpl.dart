import '../../api/Action.dart';
import '../config/Configuration.dart';
import 'SessionImpl.dart';

/// Action implementation
class ActionImpl implements Action {
  final Configuration _config;
  final SessionImpl _session;
  final String _actionName;
  final String _actionId;
  bool _isEnded = false;

  ActionImpl(this._config, this._session, this._actionName)
      : _actionId = _generateActionId();

  static String _generateActionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return 'action_${timestamp}_$random';
  }

  @override
  void reportEvent(String eventName) {
    if (_isEnded) {
      throw StateError('Cannot report event on ended action');
    }

    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .debug('Event reported: $eventName in action: $_actionName');
  }

  @override
  void reportValue(String valueName, String value) {
    if (_isEnded) {
      throw StateError('Cannot report value on ended action');
    }

    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .debug('Value reported: $valueName = $value in action: $_actionName');
  }

  @override
  void reportValueDouble(String valueName, double value) {
    if (_isEnded) {
      throw StateError('Cannot report value on ended action');
    }

    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .debug('Double value reported: $valueName = $value in action: $_actionName');
  }

  @override
  void reportValueInt(String valueName, int value) {
    if (_isEnded) {
      throw StateError('Cannot report value on ended action');
    }

    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .debug('Int value reported: $valueName = $value in action: $_actionName');
  }

  @override
  void reportError(String errorName, int errorCode, String reason) {
    if (_isEnded) {
      throw StateError('Cannot report error on ended action');
    }

    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .error('Error reported: $errorName (code: $errorCode, reason: $reason) in action: $_actionName');
  }

  @override
  void end() {
    if (_isEnded) {
      return;
    }

    _isEnded = true;
    _config.openKit.loggerFactory
        .createLogger('ActionImpl')
        .debug('Action ended: $_actionName');
  }

  @override
  bool get isEnded => _isEnded;

  @override
  String get actionId => _actionId;
}
