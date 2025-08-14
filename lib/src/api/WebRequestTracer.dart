/// Interface for web request tracing
abstract class WebRequestTracer {
  /// Set the response code
  void setResponseCode(int responseCode);
  
  /// Set the bytes sent
  void setBytesSent(int bytesSent);
  
  /// Set the bytes received
  void setBytesReceived(int bytesReceived);
  
  /// Start the web request
  void start();
  
  /// Stop the web request
  void stop();
  
  /// Check if the web request is started
  bool get isStarted;
  
  /// Check if the web request is stopped
  bool get isStopped;
}
