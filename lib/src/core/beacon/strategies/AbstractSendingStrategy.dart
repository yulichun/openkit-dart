import '../BeaconSender.dart';
import 'BeaconCache.dart';
import 'SendingStrategy.dart';

/// Abstract base class for sending strategies
abstract class AbstractSendingStrategy implements SendingStrategy {
  BeaconSender? _sender;
  BeaconCache? _cache;

  @override
  void init(dynamic beaconSender, dynamic cache) {
    _sender = beaconSender as BeaconSender;
    _cache = cache as BeaconCache;
    afterInit();
  }

  @override
  Future<void> shutdown() async {
    // Default implementation does nothing
  }

  @override
  void entryAdded(dynamic entry) {
    // Default implementation does nothing
  }

  /// Called after initialization
  void afterInit() {
    // Default implementation does nothing
  }

  /// Flush data using the beacon sender
  Future<void> flush() async {
    if (_sender != null) {
      await _sender!.flush();
    }
  }

  /// Get the beacon sender
  BeaconSender? get sender => _sender;

  /// Get the beacon cache
  BeaconCache? get cache => _cache;
}
