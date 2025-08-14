import 'AbstractSendingStrategy.dart';

/// Strategy for flushing leftover data during shutdown
class FlushLeftoversStrategy extends AbstractSendingStrategy {
  @override
  Future<void> shutdown() async {
    if (sender != null) {
      await sender!.flushImmediate();
    }
  }
}
