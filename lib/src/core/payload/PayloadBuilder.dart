import '../../api/CaptureMode.dart';
import '../beacon/CommunicationState.dart';
import '../beacon/SupplementaryBasicData.dart';
import 'Payload.dart';
import 'PayloadQueue.dart';
import 'StaticPayloadBuilder.dart';

/// Listener for payload events
abstract class PayloadBuilderListener {
  void added(Payload payload);
}

/// Builder for Dynatrace payload data
class PayloadBuilder {
  final PayloadQueue _queue = PayloadQueue();
  final List<PayloadBuilderListener> _listeners = [];

  PayloadBuilder(
    this._commState,
    this._supplementaryBasicData,
    this._trafficControlPercentage,
  );

  final CommunicationState _commState;
  final SupplementaryBasicData _supplementaryBasicData;
  final int _trafficControlPercentage;

  /// Report a named event
  void reportNamedEvent(
    String name,
    int actionId,
    int sequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportNamedEvent(
        name,
        actionId,
        sequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Send an event with JSON payload
  void sendEvent(String jsonPayload) {
    if (isCaptureDisabled()) {
      return;
    }

    _push(StaticPayloadBuilder.sendEvent(jsonPayload));
  }

  /// Report a crash
  void reportCrash(
    String errorName,
    String reason,
    String stacktrace,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureCrashesDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportCrash(
        errorName,
        reason,
        stacktrace,
        startSequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Report an error
  void reportError(
    String name,
    int errorValue,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureErrorsDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportError(
        name,
        errorValue,
        parentActionId,
        startSequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Report a value
  void reportValue(
    String name,
    String value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportValue(
        name,
        value,
        parentActionId,
        startSequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Report a double value
  void reportValueDouble(
    String name,
    double value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportValueDouble(
        name,
        value,
        parentActionId,
        startSequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Report an integer value
  void reportValueInt(
    String name,
    int value,
    int parentActionId,
    int startSequenceNumber,
    int timeSinceSessionStart,
  ) {
    if (isCaptureDisabled()) {
      return;
    }

    _push(
      StaticPayloadBuilder.reportValueInt(
        name,
        value,
        parentActionId,
        startSequenceNumber,
        timeSinceSessionStart,
      ),
    );
  }

  /// Get the next payload
  Payload? getNextPayload(String prefix, int timestamp) {
    return _queue.getNextPayload(prefix, timestamp);
  }

  /// Clear all payloads
  void clearPayload() {
    _queue.clear();
  }

  /// Check if capture is disabled
  bool isCaptureDisabled() {
    return _commState.capture == CaptureMode.off;
  }

  /// Check if error capture is disabled
  bool isCaptureErrorsDisabled() {
    return _commState.captureErrors == CaptureMode.off;
  }

  /// Check if crash capture is disabled
  bool isCaptureCrashesDisabled() {
    return _commState.captureCrashes == CaptureMode.off;
  }

  /// Add a listener
  void addListener(PayloadBuilderListener listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  void removeListener(PayloadBuilderListener listener) {
    _listeners.remove(listener);
  }

  void _push(Payload payload) {
    _queue.add(payload);
    for (final listener in _listeners) {
      listener.added(payload);
    }
  }
}
