/// Screen orientation for OpenKit
enum Orientation {
  /// Portrait orientation
  portrait('p'),
  
  /// Landscape orientation
  landscape('l');

  const Orientation(this.value);
  
  final String value;
  
  /// Get Orientation from string value
  static Orientation fromValue(String value) {
    return Orientation.values.firstWhere(
      (orientation) => orientation.value == value,
      orElse: () => Orientation.portrait,
    );
  }
}
