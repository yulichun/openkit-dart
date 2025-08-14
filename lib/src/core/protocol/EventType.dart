/// Event types for Dynatrace beacon data
enum EventType {
  /// Manual action
  manualAction(1),

  /// Named event
  namedEvent(10),

  /// String value
  valueString(11),

  /// Double value
  valueDouble(13),

  /// Session start
  sessionStart(18),

  /// Session end
  sessionEnd(19),

  /// Web request
  webRequest(30),

  /// Error
  error(40),

  /// Crash
  crash(50),

  /// Identify user
  identifyUser(60),

  /// General event
  event(98);

  const EventType(this.value);

  /// The numeric value of the event type
  final int value;
}
