/// Interface for beacon sender
abstract class BeaconSender {
  /// Flush all pending data
  Future<void> flush();

  /// Flush data immediately
  Future<void> flushImmediate();

  /// Initialize the beacon sender
  Future<void> init();

  /// Add a session to the cache
  void sessionAdded(dynamic entry);

  /// Check if the sender is initialized
  bool isInitialized();

  /// Shutdown the beacon sender
  Future<void> shutdown();
}
