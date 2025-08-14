/// Specifies the type of a network connection.
enum ConnectionType {
  /// Mobile connection type
  mobile('m'),

  /// Wireless connection type
  wifi('w'),

  /// Offline
  offline('o'),

  /// Connection via local area network
  lan('l');

  const ConnectionType(this.value);

  /// The string value of the connection type
  final String value;
}
