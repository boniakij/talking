import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../domain/repositories/call_repository.dart';
import '../../data/models/call_session_model.dart';
import '../../data/models/signaling_message_model.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository callRepository;
  
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  
  StreamSubscription? _signalingSubscription;
  StreamSubscription? _incomingCallSubscription;

  CallBloc({required this.callRepository}) : super(CallIdle()) {
    on<InitiateCall>(_onInitiateCall);
    on<ReceiveIncomingCall>(_onReceiveIncomingCall);
    on<AnswerCall>(_onAnswerCall);
    on<EndCallEvent>(_onEndCall);
    on<HandleSignaling>(_onHandleSignaling);

    _initRenderers();
    _setupListeners();
  }

  void _setupListeners() {
    _incomingCallSubscription = callRepository.incomingCallStream.listen((session) {
      add(ReceiveIncomingCall(session));
    });

    _signalingSubscription = callRepository.signalingStream.listen((message) {
      add(HandleSignaling(message));
    });
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _onInitiateCall(InitiateCall event, Emitter<CallState> emit) async {
    try {
      final session = await callRepository.startCall(event.calleeId, event.type);
      emit(CallRinging(session: session, isOutgoing: true));
      
      await _setupPeerConnection(session.id);
      
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      callRepository.sendSignalingMessage(session.id, SignalingMessage(
        type: 'offer',
        data: {'sdp': offer.sdp, 'type': offer.type},
      ));
    } catch (e) {
      emit(CallError(e.toString()));
    }
  }

  void _onReceiveIncomingCall(ReceiveIncomingCall event, Emitter<CallState> emit) {
    emit(CallRinging(session: event.session, isOutgoing: false));
  }

  Future<void> _onAnswerCall(AnswerCall event, Emitter<CallState> emit) async {
    if (state is CallRinging) {
      final session = (state as CallRinging).session;
      try {
        await callRepository.acceptCall(event.callId);
        await _setupPeerConnection(event.callId);
        emit(CallConnected(
          session: session,
          localRenderer: _localRenderer,
          remoteRenderer: _remoteRenderer,
        ));
      } catch (e) {
        emit(CallError(e.toString()));
      }
    }
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<CallState> emit) async {
    try {
      await callRepository.endCall(event.callId);
      await _disposeStreams();
      emit(CallEndedState());
    } catch (e) {
      emit(CallError(e.toString()));
    }
  }

  Future<void> _onHandleSignaling(HandleSignaling event, Emitter<CallState> emit) async {
    final message = event.message;
    
    switch (message.type) {
      case 'offer':
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(message.data['sdp'], message.data['type'])
        );
        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        
        if (state is CallRinging) {
          callRepository.sendSignalingMessage((state as CallRinging).session.id, SignalingMessage(
            type: 'answer',
            data: {'sdp': answer.sdp, 'type': answer.type},
          ));
        }
        break;
        
      case 'answer':
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(message.data['sdp'], message.data['type'])
        );
        break;
        
      case 'candidate':
        await _peerConnection?.addCandidate(
          RTCIceCandidate(
            message.data['candidate'],
            message.data['sdpMid'],
            message.data['sdpMLineIndex'],
          ),
        );
        break;
    }
  }

  Future<void> _setupPeerConnection(String callId) async {
    // Create peer connection configuration
    final configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    };
    
    _peerConnection = await createPeerConnection(configuration);
    
    _peerConnection!.onIceCandidate = (candidate) {
      callRepository.sendSignalingMessage(callId, SignalingMessage(
        type: 'candidate',
        data: {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        },
      ));
    };

    _peerConnection!.onTrack = (event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    // Add local stream
    _localStream = await callRepository.getUserMedia(CallType.video);
    _localRenderer.srcObject = _localStream;
    
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  Future<void> _disposeStreams() async {
    await _localStream?.dispose();
    await _peerConnection?.close();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
  }

  @override
  Future<void> close() async {
    await _disposeStreams();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    _signalingSubscription?.cancel();
    return super.close();
  }
}
