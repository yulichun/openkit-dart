import 'dart:async';
import 'FlushLeftoversStrategy.dart';

/// Strategy for sending data at regular intervals
class IntervalSendingStrategy extends FlushLeftoversStrategy {
  static const int _defaultLoopTimeout = 1000; // 1 second

  bool _isShutdown = false;
  Timer? _timer;

  IntervalSendingStrategy([int loopTimeout = _defaultLoopTimeout]) {
    _startTimer(loopTimeout);
  }

  @override
  void afterInit() {
    // Timer is already started in constructor
  }

  @override
  Future<void> shutdown() async {
    _isShutdown = true;
    _timer?.cancel();
    await super.shutdown();
  }

  void _startTimer(int loopTimeout) {
    _timer = Timer.periodic(Duration(milliseconds: loopTimeout), (timer) {
      if (!_isShutdown && sender != null) {
        flush();
      }
    });
  }
}
