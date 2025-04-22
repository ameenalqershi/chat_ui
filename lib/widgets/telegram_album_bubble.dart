import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TelegramAlbumBubble extends StatelessWidget {
  final List<String> imageUrls;
  final bool isMe;
  final Widget? bottomWidget;

  const TelegramAlbumBubble({
    super.key,
    required this.imageUrls,
    required this.isMe,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final int totalImages = imageUrls.length;
    final albumSize = 206.0;
    final gap = 2.0;
    final borderRadius = BorderRadius.only(
      topLeft: isMe ? const Radius.circular(19) : const Radius.circular(5),
      topRight: isMe ? const Radius.circular(5) : const Radius.circular(19),
      bottomLeft: const Radius.circular(19),
      bottomRight: const Radius.circular(19),
    );
    final gradient =
        isMe
            ? const LinearGradient(
              colors: [Color(0xff63aee1), Color(0xff3b8ed6)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
            : const LinearGradient(
              colors: [Colors.white, Color(0xfff1f1f1)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.only(
          top: 6,
          bottom: 6,
          right: isMe ? 8 : 48,
          left: isMe ? 48 : 8,
        ),
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildAlbumGrid(context, albumSize, gap),
            if (bottomWidget != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 9, left: 9),
                child: bottomWidget!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumGrid(BuildContext context, double size, double gap) {
    final int total = imageUrls.length;
    if (total == 1) {
      // صورة واحدة
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () => _openImageViewer(context, 0, imageUrls),
          child: CachedNetworkImage(
            imageUrl: imageUrls[0],
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder:
                (ctx, _) => Container(
                  color: Colors.grey.shade200,
                  width: size,
                  height: size,
                ),
          ),
        ),
      );
    } else if (total <= 4) {
      // حتى 4 صور: شبكة 2x2
      return SizedBox(
        width: size,
        height: size,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: total,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
          ),
          itemBuilder:
              (context, i) => _albumImageTile(context, i, imageUrls[i]),
        ),
      );
    } else {
      // 5 صور فأكثر: أول 3 صور عادية + رابع صورة عليها طبقة +N
      // الصور: [0,1,2,3] (الرابعة عليها overlay)
      final extraCount = total - 4;
      return SizedBox(
        width: size,
        height: size,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
          ),
          children: [
            _albumImageTile(context, 0, imageUrls[0]),
            _albumImageTile(context, 1, imageUrls[1]),
            _albumImageTile(context, 2, imageUrls[2]),
            Stack(
              fit: StackFit.expand,
              children: [
                _albumImageTile(context, 3, imageUrls[3]),
                Container(
                  color: Colors.black.withOpacity(0.44),
                  alignment: Alignment.center,
                  child: Text(
                    '+$extraCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 2)],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _albumImageTile(BuildContext context, int index, String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => _openImageViewer(context, index, imageUrls),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (ctx, _) => Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  void _openImageViewer(
    BuildContext context,
    int initialIndex,
    List<String> urls,
  ) {
    //     Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder:
    //         (_) => TelegramImageViewer(
    //           imageUrl: url,
    //           senderName: '', // يمكنك تمرير اسم المرسل هنا إذا توفّر
    //           sentAt: '', // ويمكنك تمرير الوقت إذا توفّر
    //           // لمزيد من التطوير: يمكنك تمرير قائمة الصور وأندكس الحالي لدعم ألبوم الصور
    //         ),
    //   ),
    // );
    // هنا يمكنك فتح عارض صور مخصص عند الضغط (مثل تليجرام)
    // يمكنك استكمال ذلك بمنطقك الحالي أو إضافة حوار تكبير الصورة
    // showDialog(...);
  }
}
