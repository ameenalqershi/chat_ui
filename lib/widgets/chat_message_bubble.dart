import 'package:chat_ui/models/chat_message.dart';
import 'package:chat_ui/models/message_type.dart';
import 'package:chat_ui/widgets/telegram_album_bubble.dart';
import 'package:chat_ui/widgets/voice_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'telegram_image_viewer.dart';

/// فقاعة رسالة دردشة محسنة للأداء
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final ChatMessage? repliedMsg;
  final VoidCallback? onLongPress;
  final Function(ChatMessage)? onReply;
  final Widget? reactionBar;

  const ChatMessageBubble({
    Key? key,
    required this.msg,
    this.repliedMsg,
    this.onLongPress,
    this.onReply,
    this.reactionBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = msg.isMe;

    EdgeInsets bubbleMargin = EdgeInsets.only(
      top: 4,
      bottom: 4,
      left: isMe ? 40 : 8,
      right: isMe ? 8 : 40,
    );

    // تغليف الفقاعة بـRepaintBoundary ومفتاح فريد لتعزيز الأداء
    return RepaintBoundary(
      key: ValueKey('msg_${msg.id}'),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: bubbleMargin,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onLongPress: onLongPress,
                child: _buildByType(context),
              ),
              if (reactionBar != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: reactionBar!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildByType(BuildContext context) {
    switch (msg.type) {
      case MessageType.text:
        return _buildTextBubble(context);
      case MessageType.image:
        if (msg.mediaUrl != null && msg.mediaUrl!.isNotEmpty) {
          return _buildTelegramImageBubble(context);
        }
        return _buildTextBubble(context); // fallback if no URL
      case MessageType.voice:
        return _buildVoiceBubble(context);
      case MessageType.video:
        return _buildVideoBubble(context);
      case MessageType.file:
        return _buildFileBubble(context);
      default:
        return _buildTextBubble(context);
    }
  }

  /// =========== TEXT BUBBLE (TELEGRAM STYLE) ===========
  Widget _buildTextBubble(BuildContext context) {
    final isMe = msg.isMe;
    final bubbleColor = isMe ? const Color(0xff63aee1) : Colors.white;
    final textColor = isMe ? Colors.white : const Color(0xff222a35);

    // BorderRadius مطابقة لتليجرام
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(19),
      topRight: const Radius.circular(19),
      bottomLeft: isMe ? const Radius.circular(19) : const Radius.circular(3),
      bottomRight: isMe ? const Radius.circular(3) : const Radius.circular(19),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repliedMsg != null && repliedMsg!.text.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isMe
                          ? Colors.white.withOpacity(0.16)
                          : const Color(0xffe5ebee),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  repliedMsg!.text,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        isMe ? Colors.white.withOpacity(0.82) : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // نص الرسالة
            Text(
              msg.text,
              style: TextStyle(color: textColor, fontSize: 16, height: 1.38),
            ),
            const SizedBox(height: 2),
            // الوقت + علامة ✓✓ للمرسل
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  _formatSentAt(msg.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    Icons.done_all,
                    size: 17,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// =========== SINGLE IMAGE BUBBLE (TELEGRAM STYLE) ===========
  Widget _buildTelegramImageBubble(BuildContext context) {
    return TelegramAlbumBubble(
      imageUrls: [msg.mediaUrl ?? ''],
      isMe: msg.isMe,
      bottomWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: msg.isMe ? Colors.white : Colors.black54,
              fontSize: 12,
            ),
          ),
          if (msg.isMe)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.done_all, size: 15, color: Colors.white70),
            ),
        ],
      ),
    );
  }

  /// =========== VOICE BUBBLE ===========
  Widget _buildVoiceBubble(BuildContext context) {
    return VoiceMessageBubble(
      isMe: msg.isMe,
      duration: msg.voiceDuration ?? Duration.zero,
      isPlaying: msg.isPlaying ?? false,
      onPlayPause: () {
        // logic
      },
      waveform:
          msg.waveform ??
          [
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.8,
            0.3,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.8,
            0.3,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.2,
            0.1,
            0.2,
            0.4,
            0.8,
            0.3,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
          ],
      timeString: _formatDuration(msg.voiceDuration ?? Duration.zero),
    );
  }

  /// =========== VIDEO BUBBLE ===========
  Widget _buildVideoBubble(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: msg.isMe ? const Color(0xffe0f6fd) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam, color: Colors.blue[400]),
          const SizedBox(width: 8),
          const Text("Video message", style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  /// =========== FILE BUBBLE ===========
  Widget _buildFileBubble(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: msg.isMe ? const Color(0xffe0f6fd) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file, color: Colors.blue[400]),
          const SizedBox(width: 10),
          Text(msg.fileName ?? "File", style: const TextStyle(fontSize: 15)),
          if (msg.fileSize != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                _formatFileSize(msg.fileSize!),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }

  /// =========== REPLY SNIPPET ===========
  Widget _buildReplySnippet(BuildContext context) {
    final replyColor = Colors.grey[200];
    return Container(
      decoration: BoxDecoration(
        color: replyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        repliedMsg?.text ?? "",
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// =========== BUBBLE META (TIME, STATUS) ===========
  Widget _buildBubbleMeta({bool isImage = false}) {
    final metaStyle = TextStyle(fontSize: 12, color: Colors.grey[600]);
    final time =
        "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}";
    return Padding(
      padding: EdgeInsets.only(
        top: isImage ? 0 : 1,
        right: msg.isMe ? 2 : 0,
        left: msg.isMe ? 0 : 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(time, style: metaStyle),
          if (msg.isMe) ...[
            const SizedBox(width: 4),
            Icon(Icons.done_all, size: 15, color: Colors.blue[400]),
          ],
        ],
      ),
    );
  }

  /// =========== HELPERS ===========
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final min = twoDigits(duration.inMinutes.remainder(60));
    final sec = twoDigits(duration.inSeconds.remainder(60));
    return "$min:$sec";
  }

  String _formatSentAt(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} at "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
