import 'package:flutter/material.dart';

class VoiceMessageBubble extends StatelessWidget {
  final bool isMe;
  final Duration duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final List<double> waveform;
  final String timeString;

  const VoiceMessageBubble({
    Key? key,
    required this.isMe,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    required this.waveform,
    required this.timeString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xff63aee1) : Colors.white;
    final iconColor = isMe ? Colors.white : const Color(0xff63aee1);
    final waveformColor = isMe ? Colors.white : const Color(0xff63aee1);
    final textColor = isMe ? Colors.white : const Color(0xff222a35);
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(19),
      topRight: const Radius.circular(19),
      bottomLeft: isMe ? const Radius.circular(19) : const Radius.circular(5),
      bottomRight: isMe ? const Radius.circular(5) : const Radius.circular(19),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
          minWidth: 170,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 2),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              // فقط هوامش جانبية وفوقية، ولا يوجد هوامش سفلية!
              padding: const EdgeInsets.only(
                left: 14,
                right: 14,
                top: 9,
                bottom: 18,
              ), // bottom = ارتفاع الوقت فقط
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onPlayPause,
                    child: CircleAvatar(
                      radius: 19,
                      backgroundColor: iconColor.withOpacity(0.14),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: iconColor,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 26,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _WaveformPainter(waveform, waveformColor),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          timeString,
                          style: TextStyle(
                            color: waveformColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // الوقت مثبت أسفل البابل بلا أي مسافة
            Positioned(
              right: 14,
              left: null,
              bottom: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeString,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  if (isMe)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.done_all,
                        size: 15,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveform;
  final Color color;
  _WaveformPainter(this.waveform, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    final count = waveform.length;
    final spacing = size.width / (count + 1);

    for (int i = 0; i < count; i++) {
      final x = spacing * (i + 1);
      final h = size.height * waveform[i];
      final y1 = (size.height - h) / 2;
      final y2 = y1 + h;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      oldDelegate.waveform != waveform || oldDelegate.color != color;
}
