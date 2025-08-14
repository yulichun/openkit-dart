/// Data collection level for OpenKit
enum DataCollectionLevel {
  /// No data collected
  off(0),
  
  /// Only performance related data is collected
  performance(1),
  
  /// All available RUM data including performance related data is collected
  userBehavior(2);

  const DataCollectionLevel(this.value);
  
  final int value;
  
  /// Get DataCollectionLevel from integer value
  static DataCollectionLevel fromValue(int value) {
    return DataCollectionLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => DataCollectionLevel.userBehavior,
    );
  }
}
