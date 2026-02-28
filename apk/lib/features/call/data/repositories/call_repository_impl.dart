import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:banitalk/core/network/api_client.dart';
import '../../data/models/call_session_model.dart';
import '../../data/models/signaling_message_model.dart';
import '../../domain/repositories/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  final ApiClient apiClient;
  final _signalingController = StreamController<SignalingMessage>.broadcast();

  CallRepositoryImpl({required this.apiClient});

  @override
  Stream<SignalingMessage> get signalingStream => _signalingController.stream;

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
  Future<RTCPeerConnection> createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    };

    final Map<String, dynamic> constraints = {
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
      ],
    };

    return await createPeerConnection(configuration, constraints);
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
