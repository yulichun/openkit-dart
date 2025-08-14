/// Interface for sending strategies
abstract class SendingStrategy {
  /// Initialize the strategy
  void init(dynamic beaconSender, dynamic cache);

  /// Handle entry added event
  void entryAdded(dynamic entry);

  /// Shutdown the strategy
  Future<void> shutdown();
}
