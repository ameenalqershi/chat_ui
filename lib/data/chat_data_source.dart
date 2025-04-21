import 'package:chat_ui/models/chat_message.dart';

abstract class ChatDataSource {
  /// جلب رسائل الدردشة (مع دعم التصفح - paging)
  Future<List<ChatMessage>> fetchMessages({int limit = 20, String? beforeId});

  /// إرسال رسالة
  Future<void> sendMessage(ChatMessage message);

  /// حذف رسالة
  Future<void> deleteMessage(String messageId);

  /// إضافة أو إزالة ريأكشن
  Future<void> addReaction(String messageId, String reaction, String userId);
  Future<void> removeReaction(String messageId, String reaction, String userId);

  // ... أي دوال أخرى تحتاجها شاشتك
}
