import 'package:equatable/equatable.dart';
import '../../data/models/call_session_model.dart';
import '../../data/models/signaling_message_model.dart';

abstract class CallEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitiateCall extends CallEvent {
  final int calleeId;
  final CallType type;
  InitiateCall(this.calleeId, this.type);
  @override
  List<Object?> get props => [calleeId, type];
}

class ReceiveIncomingCall extends CallEvent {
  final CallSession session;
  ReceiveIncomingCall(this.session);
  @override
  List<Object?> get props => [session];
}

class AnswerCall extends CallEvent {
  final String callId;
  AnswerCall(this.callId);
  @override
  List<Object?> get props => [callId];
}

class EndCallEvent extends CallEvent {
  final String callId;
  EndCallEvent(this.callId);
  @override
  List<Object?> get props => [callId];
}

class HandleSignaling extends CallEvent {
  final SignalingMessage message;
  HandleSignaling(this.message);
  @override
  List<Object?> get props => [message];
}
