import 'package:equatable/equatable.dart';

class ChatConversation extends Equatable {
  final String id;
  final String participantName;
  final String? participantAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ChatConversation({
    required this.id,
    required this.participantName,
    this.participantAvatar,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
        id,
        participantName,
        participantAvatar,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isOnline,
      ];
}
