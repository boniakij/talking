import 'package:equatable/equatable.dart';

enum CallStatus { idle, ringing, connected, ended, busy }
enum CallType { voice, video }

class CallSession extends Equatable {
  final String id;
  final int callerId;
  final String callerName;
  final String? callerAvatar;
  final int calleeId;
  final String calleeName;
  final String? calleeAvatar;
  final CallType type;
  final CallStatus status;
  final DateTime startTime;

  const CallSession({
    required this.id,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.calleeId,
    required this.calleeName,
    this.calleeAvatar,
    required this.type,
    required this.status,
    required this.startTime,
  });

  factory CallSession.fromJson(Map<String, dynamic> json) {
    return CallSession(
      id: json['id'].toString(),
      callerId: json['caller_id'],
      callerName: json['caller_name'] ?? 'Unknown',
      callerAvatar: json['caller_avatar'],
      calleeId: json['callee_id'],
      calleeName: json['callee_name'] ?? 'Unknown',
      calleeAvatar: json['callee_avatar'],
      type: json['type'] == 'video' ? CallType.video : CallType.voice,
      status: _parseStatus(json['status']),
      startTime: DateTime.parse(json['created_at']),
    );
  }

  static CallStatus _parseStatus(String? status) {
    switch (status) {
      case 'ringing': return CallStatus.ringing;
      case 'connected': return CallStatus.connected;
      case 'ended': return CallStatus.ended;
      case 'busy': return CallStatus.busy;
      default: return CallStatus.idle;
    }
  }

  CallSession copyWith({CallStatus? status}) {
    return CallSession(
      id: id,
      callerId: callerId,
      callerName: callerName,
      callerAvatar: callerAvatar,
      calleeId: calleeId,
      calleeName: calleeName,
      calleeAvatar: calleeAvatar,
      type: type,
      status: status ?? this.status,
      startTime: startTime,
    );
  }

  @override
  List<Object?> get props => [id, callerId, calleeId, type, status];
}
