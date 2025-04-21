import 'package:chat_ui/models/message_type.dart';

class ChatMessage {
  final String id;
  final String text;
  final String? mediaUrl;
  final MessageType type;
  final bool isMe;
  final DateTime createdAt;
  final bool isDeleted;
  final bool isEdited;
  final bool isPinned;
  final String? replyToMessageId;
  final String? fileName;
  final int? fileSize;
  final String? replyTo;

  // خصائص جديدة لدعم الدردشة الحديثة:
  final String? sender; // اسم المرسل (اختياري)
  final String? avatarUrl; // صورة المرسل (اختياري)
  final bool? isRead; // مؤشر القراءة (اختياري)
  final String? forwardedFrom; // اسم المرسل الأصلي (اختياري)
  final DateTime? editedAt; // وقت التعديل (اختياري)
  final Map<String, List<String>> reactions;

  ChatMessage({
    required this.id,
    required this.text,
    this.mediaUrl,
    required this.type,
    required this.isMe,
    required this.createdAt,
    this.isDeleted = false,
    this.isEdited = false,
    this.isPinned = false,
    this.replyToMessageId,
    this.fileName,
    this.fileSize,
    this.replyTo,
    // الجدد
    this.sender,
    this.avatarUrl,
    this.isRead,
    this.forwardedFrom,
    this.editedAt,
    this.reactions = const {}, // افتراضي فارغ
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    String? mediaUrl,
    MessageType? type,
    bool? isMe,
    DateTime? createdAt,
    bool? isDeleted,
    bool? isEdited,
    bool? isPinned,
    String? replyToMessageId,
    String? fileName,
    int? fileSize,
    String? replyTo,
    String? sender,
    String? avatarUrl,
    bool? isRead,
    String? forwardedFrom,
    DateTime? editedAt,
    Map<String, List<String>>? reactions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      type: type ?? this.type,
      isMe: isMe ?? this.isMe,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      replyTo: replyTo ?? this.replyTo,
      sender: sender ?? this.sender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isRead: isRead ?? this.isRead,
      forwardedFrom: forwardedFrom ?? this.forwardedFrom,
      editedAt: editedAt ?? this.editedAt,
      reactions: reactions ?? this.reactions,
    );
  }
}
