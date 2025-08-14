import 'dart:convert';
import 'dart:math';

/// Hash utility functions for OpenKit
class HashUtils {
  /// Convert string to 53-bit hash
  static int to53BitHash(String input) {
    if (input.isEmpty) return 0;
    
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      final char = input.codeUnitAt(i);
      hash = ((hash << 5) - hash + char) & 0x1FFFFFFFFFFFFF; // 53 bits
    }
    
    return hash.abs();
  }
  
  /// Generate a simple hash from string
  static int simpleHash(String input) {
    if (input.isEmpty) return 0;
    
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash + input.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    
    return hash.abs();
  }
}
