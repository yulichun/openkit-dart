import '../../api/CommunicationChannel.dart';
import '../../api/Logger.dart';
import '../../api/LoggerFactory.dart';
import '../config/Configuration.dart';
import '../impl/OpenKitImpl.dart';
import '../payload/Payload.dart';
import 'BeaconSender.dart';
import 'CommunicationState.dart';
import 'CommunicationStateImpl.dart';
import 'StatusRequestImpl.dart';
import 'strategies/SendingStrategy.dart';
import 'strategies/BeaconCache.dart';

/// Implementation of BeaconSender
class BeaconSenderImpl implements BeaconSender {
  final String _appId;
  final String _beaconUrl;
  final List<SendingStrategy> _sendingStrategies;
  final CommunicationChannel _channel;
  final Logger _logger;
  final String _deviceId;
  final BeaconCache _cache;

  int _okServerId = 1; // Default server ID
  bool _isShutdown = false;
  bool _initialized = false;
  bool _flushing = false;

  BeaconSenderImpl(
    OpenKitImpl openKit,
    BeaconCache cache,
    Configuration config,
  )   : _appId = config.openKit.applicationId,
        _beaconUrl = config.openKit.beaconURL,
        _channel = config.openKit.communicationChannel,
        _sendingStrategies = config.openKit.sendingStrategies,
        _deviceId = config.openKit.deviceId,
        _cache = cache,
        _logger = config.openKit.loggerFactory.createLogger('BeaconSender');

  @override
  Future<void> init() async {
    _logger.info('Initializing beacon sender');

    try {
      final response = await _channel.sendStatusRequest(
        _beaconUrl,
        StatusRequestImpl.create(_appId, _okServerId, 0),
      );

      if (response.isValid) {
        _initialized = true;
        _okServerId = response.serverId ?? 1;

        // Update communication state for all cached entries
        for (final entry in _cache.getEntriesCopy()) {
          entry.communicationState.setServerId(_okServerId);
        }

        // Initialize sending strategies
        for (final strategy in _sendingStrategies) {
          strategy.init(this, _cache);
        }

        _logger.info('Beacon sender initialized successfully');
      } else {
        _logger.warning('Failed to initialize beacon sender');
      }
    } catch (e) {
      _logger.error('Error initializing beacon sender: $e');
    }
  }

  @override
  void sessionAdded(dynamic entry) {
    if (entry is CacheEntry) {
      entry.communicationState.setServerId(_okServerId);

      for (final strategy in _sendingStrategies) {
        strategy.entryAdded(entry);
      }
    }
  }

  @override
  bool isInitialized() => _initialized;

  @override
  Future<void> shutdown() async {
    if (_isShutdown) return;

    _isShutdown = true;
    _logger.info('Shutting down beacon sender');

    // Close all sessions
    for (final entry in _cache.getEntriesCopy()) {
      entry.session.end();
    }

    // Shutdown sending strategies
    for (final strategy in _sendingStrategies) {
      await strategy.shutdown();
    }

    _logger.info('Beacon sender shutdown complete');
  }

  @override
  Future<void> flush() async {
    if (_flushing) return;

    _flushing = true;
    _logger.debug('Flushing beacon data');

    if (_initialized) {
      await _sendNewSessionRequests(false);
      await _sendPayloadData();
      await _finishSessions();
    }

    _flushing = false;
  }

  @override
  Future<void> flushImmediate() async {
    if (_initialized) {
      await _sendNewSessionRequests(true);
      await _sendPayloadData();
      await _finishSessions();
    }
  }

  Future<void> _sendNewSessionRequests(bool immediate) async {
    final entries = _cache.getAllUninitializedSessions();

    if (immediate) {
      // Mark all sessions as initialized immediately
      for (final entry in entries) {
        entry.communicationState.setServerId(_okServerId);
        entry.communicationState.setServerIdLocked();
        entry.initialized = true;
      }
    } else {
      // Send new session requests
      for (final entry in entries) {
        await _sendNewSessionRequest(entry);
      }
    }
  }

  Future<void> _sendNewSessionRequest(dynamic entry) async {
    try {
      if (entry is CacheEntry) {
        final response = await _channel.sendNewSessionRequest(
          _beaconUrl,
          StatusRequestImpl.createNewSession(
            _appId,
            entry.communicationState.serverId,
            entry.communicationState.timestamp,
            _deviceId,
            entry.session.sessionId,
          ),
        );

        if (response.isValid) {
          entry.communicationState.updateFromResponse(response);
          entry.communicationState.setServerIdLocked();
          entry.initialized = true;
        }
      }
    } catch (e) {
      _logger.error('Error sending new session request: $e');
    }
  }

  Future<void> _finishSessions() async {
    final entries = _cache.getAllClosedSessions();

    for (final entry in entries) {
      await _sendPayload(entry);
      _cache.unregister(entry);
    }
  }

  Future<void> _sendPayloadData() async {
    final entries = _cache.getAllInitializedSessions();

    for (final entry in entries) {
      if (!entry.builder.isCaptureDisabled()) {
        await _sendPayload(entry);
      } else {
        entry.builder.clearPayload();
      }
    }
  }

  Future<void> _sendPayload(dynamic entry) async {
    try {
      if (entry is CacheEntry) {
        Payload? payload;
        while ((payload = entry.builder.getNextPayload(
              entry.prefix,
              DateTime.now().millisecondsSinceEpoch,
            )) !=
            null) {
          final request = StatusRequestImpl.createNewSession(
            _appId,
            entry.communicationState.serverId,
            entry.communicationState.timestamp,
            _deviceId,
            entry.session.sessionId,
          );

          final response = await _channel.sendPayloadData(
            _beaconUrl,
            request,
            payload!,
          );

          entry.communicationState.updateFromResponse(response);
        }
      }
    } catch (e) {
      _logger.error('Error sending payload: $e');
    }
  }
}
