import 'Session.dart';

/// Main interface for OpenKit
abstract class OpenKit {
  /// Initialize OpenKit
  Future<void> initialize();
  
  /// Create a new session
  Session createSession(String clientIPAddress);
  
  /// Create a new session with user ID
  Session createSessionWithUserId(String clientIPAddress, String userId);
  
  /// Shutdown OpenKit
  Future<void> shutdown();
  
  /// Check if OpenKit is initialized
  bool get isInitialized;
  
  /// Check if OpenKit is shutdown
  bool get isShutdown;
}
