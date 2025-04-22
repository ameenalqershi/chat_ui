import 'package:chat_ui/models/message_type.dart';

class ChatMessage {
  final String id;
  final String text;
  final String? mediaUrl;
  final MessageType type;
  final bool isMe;
  final bool isDeleted;
  final bool isEdited;
  final bool isPinned;
  final String? replyToMessageId;
  final String? fileName;
  final int? fileSize;
  final String? replyTo;
  final Duration? voiceDuration;
  final bool? isPlaying;
  final List<double>? waveform;
  final DateTime createdAt;

  // خصائص جديدة لدعم الدردشة الحديثة:
  final String? sender; // اسم المرسل (اختياري)
  final String? avatarUrl; // صورة المرسل (اختياري)
  final bool? isRead; // مؤشر القراءة (اختياري)
  final String? forwardedFrom; // اسم المرسل الأصلي (اختياري)
  final DateTime? editedAt; // وقت التعديل (اختياري)
  final Map<String, List<String>> reactions; // التفاعلات (إيموجي: [userIds])

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
    this.voiceDuration,
    this.isPlaying,
    this.waveform,
    this.sender,
    this.avatarUrl,
    this.isRead,
    this.forwardedFrom,
    this.editedAt,
    this.reactions = const {},
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
    Duration? voiceDuration,
    bool? isPlaying,
    List<double>? waveform,
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
      voiceDuration: voiceDuration ?? this.voiceDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      waveform: waveform ?? this.waveform,
      sender: sender ?? this.sender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isRead: isRead ?? this.isRead,
      forwardedFrom: forwardedFrom ?? this.forwardedFrom,
      editedAt: editedAt ?? this.editedAt,
      reactions: reactions ?? this.reactions,
    );
  }

  // تحويل إلى Map (مثالي للتخزين في قاعدة بيانات أو JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'mediaUrl': mediaUrl,
      'type': type.index,
      'isMe': isMe,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'isEdited': isEdited,
      'isPinned': isPinned,
      'replyToMessageId': replyToMessageId,
      'fileName': fileName,
      'fileSize': fileSize,
      'replyTo': replyTo,
      'voiceDuration': voiceDuration?.inMilliseconds,
      'isPlaying': isPlaying,
      'waveform': waveform,
      'sender': sender,
      'avatarUrl': avatarUrl,
      'isRead': isRead,
      'forwardedFrom': forwardedFrom,
      'editedAt': editedAt?.toIso8601String(),
      'reactions': reactions,
    };
  }

  // إنشاء من Map (مثالي من قاعدة بيانات أو JSON)
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      mediaUrl: map['mediaUrl'],
      type: MessageType.values[map['type'] ?? 0],
      isMe: map['isMe'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      isDeleted: map['isDeleted'] ?? false,
      isEdited: map['isEdited'] ?? false,
      isPinned: map['isPinned'] ?? false,
      replyToMessageId: map['replyToMessageId'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      replyTo: map['replyTo'],
      voiceDuration:
          map['voiceDuration'] != null
              ? Duration(milliseconds: map['voiceDuration'])
              : null,
      isPlaying: map['isPlaying'],
      waveform:
          map['waveform'] != null ? List<double>.from(map['waveform']) : null,
      sender: map['sender'],
      avatarUrl: map['avatarUrl'],
      isRead: map['isRead'],
      forwardedFrom: map['forwardedFrom'],
      editedAt:
          map['editedAt'] != null ? DateTime.parse(map['editedAt']) : null,
      reactions:
          map['reactions'] != null
              ? Map<String, List<String>>.from(
                (map['reactions'] as Map).map(
                  (k, v) => MapEntry(k as String, List<String>.from(v)),
                ),
              )
              : {},
    );
  }

  // دعم == وhashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          mediaUrl == other.mediaUrl &&
          type == other.type &&
          isMe == other.isMe &&
          createdAt == other.createdAt &&
          isDeleted == other.isDeleted &&
          isEdited == other.isEdited &&
          isPinned == other.isPinned &&
          replyToMessageId == other.replyToMessageId &&
          fileName == other.fileName &&
          fileSize == other.fileSize &&
          replyTo == other.replyTo &&
          voiceDuration == other.voiceDuration &&
          isPlaying == other.isPlaying &&
          waveform == other.waveform &&
          sender == other.sender &&
          avatarUrl == other.avatarUrl &&
          isRead == other.isRead &&
          forwardedFrom == other.forwardedFrom &&
          editedAt == other.editedAt &&
          _mapEquals(reactions, other.reactions);

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      (mediaUrl?.hashCode ?? 0) ^
      type.hashCode ^
      isMe.hashCode ^
      createdAt.hashCode ^
      isDeleted.hashCode ^
      isEdited.hashCode ^
      isPinned.hashCode ^
      (replyToMessageId?.hashCode ?? 0) ^
      (fileName?.hashCode ?? 0) ^
      (fileSize?.hashCode ?? 0) ^
      (replyTo?.hashCode ?? 0) ^
      (voiceDuration?.hashCode ?? 0) ^
      (isPlaying?.hashCode ?? 0) ^
      (waveform?.hashCode ?? 0) ^
      (sender?.hashCode ?? 0) ^
      (avatarUrl?.hashCode ?? 0) ^
      (isRead?.hashCode ?? 0) ^
      (forwardedFrom?.hashCode ?? 0) ^
      (editedAt?.hashCode ?? 0) ^
      reactions.hashCode;

  static bool _mapEquals(
    Map<String, List<String>> a,
    Map<String, List<String>> b,
  ) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (a[key]!.length != b[key]!.length) return false;
      for (int i = 0; i < a[key]!.length; i++) {
        if (a[key]![i] != b[key]![i]) return false;
      }
    }
    return true;
  }
}
