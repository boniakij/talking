import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/models/call_session_model.dart';

abstract class CallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CallIdle extends CallState {}

class CallRinging extends CallState {
  final CallSession session;
  final bool isOutgoing;
  CallRinging({required this.session, required this.isOutgoing});
  @override
  List<Object?> get props => [session, isOutgoing];
}

class CallConnected extends CallState {
  final CallSession session;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  CallConnected({
    required this.session,
    required this.localRenderer,
    required this.remoteRenderer,
  });
  @override
  List<Object?> get props => [session, localRenderer, remoteRenderer];
}

class CallEndedState extends CallState {}

class CallError extends CallState {
  final String message;
  CallError(this.message);
  @override
  List<Object?> get props => [message];
}
