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
    // ألوان تليجرام للصوت
    final bubbleColor = const Color(0xffd2f8c6); // أخضر فاتح
    final playButtonColor = const Color(0xff34c759); // أخضر غامق
    final waveformColor = const Color(0xff34c759); // نفس زر التشغيل
    final durationColor = const Color(0xff34c759);
    final metaColor = const Color(0xff5eab6e); // رمادي مخضر للوقت

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          minWidth: 170,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // زر التشغيل
            GestureDetector(
              onTap: onPlayPause,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: playButtonColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // موجة الصوت
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 28,
                    child: CustomPaint(
                      painter: _WaveformPainter(waveform, waveformColor),
                      size: Size(double.infinity, 28),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // المدة باللون الأخضر الغامق تحت الموجة
                  Text(
                    timeString,
                    style: TextStyle(
                      color: durationColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            // الوقت في الأسفل يمين الفقاعة
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: metaColor, fontSize: 11),
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
          ..strokeWidth = 2.5
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
