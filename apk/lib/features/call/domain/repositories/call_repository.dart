import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/models/call_session_model.dart';
import '../../data/models/signaling_message_model.dart';

abstract class CallRepository {
  Future<CallSession> startCall(int calleeId, CallType type);
  Future<void> acceptCall(String callId);
  Future<void> rejectCall(String callId);
  Future<void> endCall(String callId);

  // WebSocket methods
  void initWebSocket(String token);
  void disposeWebSocket();
  Stream<SignalingMessage> get signalingStream;
  Stream<CallSession> get incomingCallStream;
  void sendSignalingMessage(String callId, SignalingMessage message);
  
  // Local Media
  Future<MediaStream> getUserMedia(CallType type);
}
