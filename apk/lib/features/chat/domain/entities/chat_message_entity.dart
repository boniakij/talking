import 'package:equatable/equatable.dart';

enum ChatMessageType { text, image, audio, video, file }

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final ChatMessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;
  final String? replyToMessageId;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.type = ChatMessageType.text,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.replyToMessageId,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        type,
        timestamp,
        isRead,
        mediaUrl,
        replyToMessageId,
      ];
}
