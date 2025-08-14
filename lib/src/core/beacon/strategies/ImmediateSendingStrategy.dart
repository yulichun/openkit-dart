import '../../payload/Payload.dart';
import '../../payload/PayloadBuilder.dart';
import '../../protocol/EventType.dart';
import 'BeaconCache.dart';
import 'FlushLeftoversStrategy.dart';

/// Strategy for immediately sending data when certain events occur
class ImmediateSendingStrategy extends FlushLeftoversStrategy
    implements PayloadBuilderListener {
  final List<EventType> _flushEventTypes;

  ImmediateSendingStrategy([List<EventType>? flushEventTypes])
      : _flushEventTypes = flushEventTypes ??
            [
              EventType.crash,
              EventType.error,
              EventType.manualAction,
              EventType.identifyUser,
              EventType.sessionStart,
              EventType.sessionEnd,
              EventType.webRequest,
            ];

  @override
  void afterInit() {
    flush();
  }

  @override
  void added(Payload payload) {
    if (sender == null) {
      return;
    }

    final eventType = _getEventType(payload);
    if (eventType != null && _shouldFlush(eventType)) {
      flush();
    }
  }

  @override
  void entryAdded(dynamic entry) {
    if (entry is CacheEntry) {
      entry.builder.addListener(this);
    }
  }

  bool _shouldFlush(EventType eventType) {
    return _flushEventTypes.contains(eventType);
  }

  EventType? _getEventType(Payload payload) {
    if (!payload.startsWith('et=')) {
      return null;
    }

    final value = payload.substring(
      payload.indexOf('=') + 1,
      payload.indexOf('&'),
    );

    final eventTypeValue = int.tryParse(value);
    if (eventTypeValue == null) {
      return null;
    }

    try {
      return EventType.values.firstWhere((et) => et.value == eventTypeValue);
    } catch (e) {
      return null;
    }
  }
}
