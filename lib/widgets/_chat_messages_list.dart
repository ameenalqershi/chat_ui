// import 'package:chat_ui/widgets/chat_grouped_images.dart';
// import 'package:flutter/material.dart';
// import 'chat_message_bubble.dart';
// // import 'chat_grouped_images.dart'; // غير مستخدم حالياً
// import 'package:chat_ui/models/chat_message.dart';
// import 'package:chat_ui/models/message_type.dart';

// class ChatMessagesList extends StatelessWidget {
//   final ChatDataSource dataSource;
//   const ChatMessagesList({super.key, required this.dataSource});

//   @override
//   Widget build(BuildContext context) {
//     // تقسيم الرسائل بحسب الصور أو نصوص (grouping)
//     final grouped = groupImageMessages(dataSource.messages);

//     return ListView.builder(
//       reverse: true,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       itemCount: grouped.length,
//       itemBuilder: (ctx, idx) {
//         final group = grouped[grouped.length - 1 - idx];

//         // رسائل نصية أو صوتية إلخ (فقاعة منفردة)
//         if (group.length == 1 && group.first.type != MessageType.image) {
//           return RepaintBoundary(
//             key: ValueKey('msg_${group.first.id}'), // مفتاح فريد للرسالة
//             child: ChatMessageBubble(msg: group.first),
//           );
//         }
//         // مجموعة صور (ألبوم صور)
//         else if (group.length >= 1 && group.first.type == MessageType.image) {
//           // مفتاح فريد للألبوم
//           return RepaintBoundary(
//             key: ValueKey('img_album_${group.first.id}'),
//             // ملاحظة: ChatGroupedImagesBubble غير مستخدم حالياً حسب كلامك
//             child: Column(
//               children:
//                   group.map((imgMsg) {
//                     return ChatMessageBubble(
//                       key: ValueKey('msg_${imgMsg.id}'),
//                       msg: imgMsg,
//                     );
//                   }).toList(),
//             ),
//           );
//         }

//         return const SizedBox.shrink();
//       },
//     );
//   }
// }

// // ========== ملاحظة =========
// // إذا فعلاً لا تستخدم ChatGroupedImagesBubble، عُدّل أعلاه لعرض كل صورة كفقاعة مستقلة.
// // لو كنت ستستخدم grouping مستقبلاً، أعِد تفعيل الكود الأصلي.
