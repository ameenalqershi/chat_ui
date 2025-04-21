// import 'package:flutter/material.dart';
// import 'package:chat_ui/models/chat_message.dart';
// import 'package:chat_ui/models/message_type.dart';

// class PinnedMessageBar extends StatelessWidget {
//   final ChatDataSource dataSource;
//   const PinnedMessageBar({super.key, required this.dataSource});

//   @override
//   Widget build(BuildContext context) {
//     final pinned = dataSource.pinnedMessage;
//     if (pinned == null) return const SizedBox.shrink();
//     return Container(
//       color: Colors.yellow.shade100,
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         children: [
//           const Icon(Icons.push_pin, color: Colors.orange),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               pinned.text,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () => dataSource.unpinMessage(),
//           ),
//         ],
//       ),
//     );
//   }
// }
