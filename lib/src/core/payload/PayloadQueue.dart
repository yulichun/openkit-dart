import 'Payload.dart';

/// Queue for managing payload data
class PayloadQueue {
  final List<Payload> _queue = [];
  int _sequenceNumber = 0;

  /// Add a payload to the queue
  void add(Payload payload) {
    _queue.add(payload);
  }

  /// Get the next payload with prefix and timestamp
  Payload? getNextPayload(String prefix, int timestamp) {
    if (_queue.isEmpty) {
      return null;
    }

    final payload = _queue.removeAt(0);
    _sequenceNumber++;

    // Add sequence number and timestamp to payload
    return '$prefix&sn=$_sequenceNumber&ts=$timestamp&$payload';
  }

  /// Clear all payloads
  void clear() {
    _queue.clear();
    _sequenceNumber = 0;
  }

  /// Get the current queue size
  int get size => _queue.length;

  /// Check if queue is empty
  bool get isEmpty => _queue.isEmpty;
}
