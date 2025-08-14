/// Interface for supplementary basic data
abstract class SupplementaryBasicData {
  /// Get the device ID
  String get deviceId;

  /// Get the application ID
  String get applicationId;

  /// Get the operating system
  String get operatingSystem;

  /// Get the application version
  String? get applicationVersion;

  /// Get the manufacturer
  String? get manufacturer;

  /// Get the model ID
  String? get modelId;

  /// Get the user language
  String? get userLanguage;

  /// Get the screen width
  int? get screenWidth;

  /// Get the screen height
  int? get screenHeight;

  /// Get the orientation
  String? get orientation;
}
