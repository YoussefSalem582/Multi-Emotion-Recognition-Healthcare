import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Application logo widget
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({super.key, this.size = 120, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C5BB5), Color(0xFF2B4B8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size / 5),
          ),
          child: CustomPaint(painter: LogoPainter(), size: Size(size, size)),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'EmoSense',
            style: TextStyle(
              fontSize: size / 4,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF2B4B8C),
            ),
          ),
        ],
      ],
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 1024;

    // Move to center and scale
    canvas.translate(centerX, centerY);
    canvas.scale(scale * 0.65);

    // Speech bubble
    final bubblePaint =
        Paint()
          ..color = const Color(0xFFFFFDF5)
          ..style = PaintingStyle.fill;

    final bubblePath =
        Path()
          ..moveTo(-300, -100)
          ..cubicTo(-450, -100, -550, 0, -550, 150)
          ..cubicTo(-550, 300, -450, 400, -300, 400)
          ..lineTo(-250, 400)
          ..lineTo(-250, 500)
          ..lineTo(-100, 400)
          ..lineTo(300, 400)
          ..cubicTo(450, 400, 550, 300, 550, 150)
          ..cubicTo(550, 0, 450, -100, 300, -100)
          ..close();

    canvas.drawPath(bubblePath, bubblePaint);

    // Headset
    final headsetPaint =
        Paint()
          ..color = const Color(0xFF2B4B8C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 60
          ..strokeCap = StrokeCap.round;

    // Left earpiece
    final leftHeadsetPath =
        Path()
          ..moveTo(-550, 150)
          ..cubicTo(-550, 150, -650, 150, -650, 50)
          ..cubicTo(-650, -50, -550, -50, -550, -50);

    // Right earpiece
    final rightHeadsetPath =
        Path()
          ..moveTo(550, 150)
          ..cubicTo(550, 150, 650, 150, 650, 50)
          ..cubicTo(650, -50, 550, -50, 550, -50);

    // Headset extension
    final extensionPath =
        Path()
          ..moveTo(550, 150)
          ..cubicTo(550, 150, 550, 300, 450, 400);

    canvas.drawPath(leftHeadsetPath, headsetPaint);
    canvas.drawPath(rightHeadsetPath, headsetPaint);
    canvas.drawPath(extensionPath, headsetPaint);

    // Sad emoji
    final sadEmojiPaint =
        Paint()
          ..color = const Color(0xFFFFDA44)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(-200, 150), 100, sadEmojiPaint);

    // Sad emoji eyes
    final eyePaint =
        Paint()
          ..color = const Color(0xFF2B4B8C)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(-230, 110), 15, eyePaint);
    canvas.drawCircle(const Offset(-170, 110), 15, eyePaint);

    // Sad emoji mouth
    final mouthPaint =
        Paint()
          ..color = const Color(0xFF2B4B8C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(-200, 200);
    canvas.rotate(math.pi);
    final sadMouthPath =
        Path()
          ..moveTo(-50, 0)
          ..cubicTo(-50, 30, 50, 30, 50, 0);
    canvas.drawPath(sadMouthPath, mouthPaint);
    canvas.restore();

    // Neutral emoji
    final neutralEmojiPaint =
        Paint()
          ..color = const Color(0xFFFF9811)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, 150), 100, neutralEmojiPaint);

    // Neutral emoji eyes
    canvas.drawCircle(const Offset(-30, 110), 15, eyePaint);
    canvas.drawCircle(const Offset(30, 110), 15, eyePaint);

    // Neutral emoji mouth
    canvas.drawLine(const Offset(-40, 200), const Offset(40, 200), mouthPaint);

    // Happy emoji
    final happyEmojiPaint =
        Paint()
          ..color = const Color(0xFF7ED957)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(200, 150), 100, happyEmojiPaint);

    // Happy emoji eyes
    canvas.drawCircle(const Offset(170, 110), 15, eyePaint);
    canvas.drawCircle(const Offset(230, 110), 15, eyePaint);

    // Happy emoji mouth
    final happyMouthPath =
        Path()
          ..moveTo(150, 200)
          ..cubicTo(150, 230, 250, 230, 250, 200);
    canvas.drawPath(happyMouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
