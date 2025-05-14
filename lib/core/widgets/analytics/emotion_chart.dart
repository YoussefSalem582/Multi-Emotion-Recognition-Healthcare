import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A chart widget for displaying emotion distribution
class EmotionChart extends StatelessWidget {
  final Map<String, double> emotions;
  final Map<String, Color> colors;
  final double size;

  const EmotionChart({
    Key? key,
    required this.emotions,
    required this.colors,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _EmotionChartPainter(emotions: emotions, colors: colors),
          ),
        ),
        SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children:
          emotions.keys.map((emotion) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[emotion],
                  ),
                ),
                SizedBox(width: 4),
                Text('$emotion (${(emotions[emotion]! * 100).toInt()}%)'),
              ],
            );
          }).toList(),
    );
  }
}

class _EmotionChartPainter extends CustomPainter {
  final Map<String, double> emotions;
  final Map<String, Color> colors;

  _EmotionChartPainter({required this.emotions, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2; // Start from top

    emotions.forEach((emotion, value) {
      final sweepAngle = 2 * math.pi * value;
      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = colors[emotion] ?? Colors.grey;

      // Draw arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw label if segment is large enough
      if (value >= 0.1) {
        final labelAngle = startAngle + (sweepAngle / 2);
        final labelRadius = radius * 0.7;
        final labelX = center.dx + labelRadius * math.cos(labelAngle);
        final labelY = center.dy + labelRadius * math.sin(labelAngle);

        final textSpan = TextSpan(
          text: '${(value * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelX - textPainter.width / 2,
            labelY - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
