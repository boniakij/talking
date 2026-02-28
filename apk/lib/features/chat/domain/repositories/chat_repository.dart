import 'entities/chat_conversation_entity.dart';
import 'entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatConversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId);
  Future<ChatMessage> sendMessage(String conversationId, String content, ChatMessageType type);
  Future<void> markAsRead(String conversationId);
  
  // WebSocket methods
  void initWebSocket(String token);
  void disposeWebSocket();
  Stream<ChatMessage> get messageStream;
}
