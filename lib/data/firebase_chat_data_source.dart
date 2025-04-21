import 'chat_data_source.dart';
import '../models/chat_message.dart';

class ApiChatDataSource implements ChatDataSource {
  @override
  Future<List<ChatMessage>> fetchMessages({
    int limit = 20,
    String? beforeId,
  }) async {
    // استدعاء API وجلب الرسائل...
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    // إرسال الرسالة للـ API
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addReaction(
    String messageId,
    String reaction,
    String userId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> removeReaction(
    String messageId,
    String reaction,
    String userId,
  ) async {
    throw UnimplementedError();
  }
}
