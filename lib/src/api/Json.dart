/// Interface for JSON serialization
abstract class Json {
  /// Convert object to JSON string
  String toJson();
  
  /// Create object from JSON string
  static T fromJson<T>(String json, T Function(Map<String, dynamic>) fromJsonT) {
    return fromJsonT(Map<String, dynamic>.from(json as Map));
  }
}
