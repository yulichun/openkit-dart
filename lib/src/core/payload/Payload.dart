import '../protocol/EventType.dart';

/// Payload type for Dynatrace beacon data
typedef Payload = String;

/// Combine two payloads
Payload combinePayloads(Payload p1, Payload p2) => '$p1&$p2';

/// Get event type from payload
EventType? getEventType(Payload payload) {
  if (!payload.startsWith('et')) {
    return null;
  }

  final value = payload.substring(
    payload.indexOf('=') + 1,
    payload.indexOf('&'),
  );

  return EventType.values[int.tryParse(value) ?? 0];
}
