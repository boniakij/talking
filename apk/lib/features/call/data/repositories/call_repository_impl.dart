import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:banitalk/core/network/api_client.dart';
import '../../data/models/call_session_model.dart';
import '../../data/models/signaling_message_model.dart';
import '../../domain/repositories/call_repository.dart';

import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

class CallRepositoryImpl implements CallRepository {
  final ApiClient apiClient;
  final _signalingController = StreamController<SignalingMessage>.broadcast();
  final _incomingCallController = StreamController<CallSession>.broadcast();
  Echo? _echo;

  CallRepositoryImpl({required this.apiClient});

  @override
  Stream<SignalingMessage> get signalingStream => _signalingController.stream;

  @override
  Stream<CallSession> get incomingCallStream => _incomingCallController.stream;

  @override
  void initWebSocket(String token) {
    PusherOptions options = PusherOptions(
      host: 'localhost',
      encrypted: false,
      cluster: 'mt1',
      auth: PusherAuth(
        '${apiClient.dio.options.baseUrl}/broadcasting/auth',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    PusherClient pusher = PusherClient('local', options, autoConnect: true);

    _echo = Echo(
      client: pusher,
      broadcaster: EchoBroadcasterType.Pusher,
    );

    // Listen for incoming calls
    _echo?.private('calls').listen('IncomingCall', (data) {
      final session = CallSession.fromJson(data['session']);
      _incomingCallController.add(session);
    });

    // Listen for signaling messages
    _echo?.private('calls').listen('SignalingEvent', (data) {
      final message = SignalingMessage.fromJson(data['message']);
      _signalingController.add(message);
    });
  }

  @override
  void disposeWebSocket() {
    _echo?.disconnect();
    _signalingController.close();
    _incomingCallController.close();
  }

  @override
  Future<CallSession> startCall(int calleeId, CallType type) async {
    try {
      final response = await apiClient.dio.post('/calls/initiate', data: {
        'callee_id': calleeId,
        'type': type.name,
      });
      return CallSession.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptCall(String callId) async {
    await apiClient.dio.post('/calls/$callId/accept');
  }

  @override
  Future<void> rejectCall(String callId) async {
    await apiClient.dio.post('/calls/$callId/reject');
  }

  @override
  Future<void> endCall(String callId) async {
    await apiClient.dio.post('/calls/$callId/end');
  }

  @override
  void sendSignalingMessage(String callId, SignalingMessage message) {
    apiClient.dio.post('/calls/$callId/signaling', data: message.toJson());
  }

  @override
  Future<MediaStream> getUserMedia(CallType type) async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': type == CallType.video
          ? {
              'facingMode': 'user',
              'width': {'ideal': 1280},
              'height': {'ideal': 720},
            }
          : false,
    };

    return await navigator.mediaDevices.getUserMedia(constraints);
  }
}
