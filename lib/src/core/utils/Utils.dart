import 'dart:io';

/// Utility functions for OpenKit
class Utils {
  /// Check if running on Node.js (server environment)
  static bool get isNode => !isWeb;
  
  /// Check if running on web
  static bool get isWeb => identical(0, 0.0);
  
  /// Check if value is a valid integer
  static bool isInteger(dynamic value) {
    if (value is int) return true;
    if (value is double) return value == value.toInt();
    if (value is String) {
      try {
        int.parse(value);
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }
  
  /// Truncate string to specified length
  static String truncate(String? value, [int maxLength = 250]) {
    if (value == null || value.isEmpty) return '';
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...';
  }
}
