import 'StatusRequest.dart';
import 'StatusResponse.dart';

/// Interface for communication channel
abstract class CommunicationChannel {
  /// Send a status request and get response
  Future<StatusResponse> sendStatusRequest(String url, StatusRequest request);

  /// Send a new session request
  Future<StatusResponse> sendNewSessionRequest(
      String url, StatusRequest request);

  /// Send payload data
  Future<StatusResponse> sendPayloadData(
      String url, StatusRequest request, String payload);

  /// Check if the communication channel is available
  bool isAvailable();

  /// Initialize the communication channel
  Future<void> initialize();

  /// Close the communication channel
  Future<void> close();
}
