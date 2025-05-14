import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../models/analytics_data.dart';

/// A custom painter for drawing customer segments in a donut chart
class SegmentsPainter extends CustomPainter {
  final List<CustomerSegment> segments;
  final String centerText;

  SegmentsPainter({
    required this.segments,
    this.centerText = 'Customer\nEmotions',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final outerRadius = radius * 0.9;
    final innerRadius = radius * 0.6;

    double startAngle = -math.pi / 2; // Start from top

    for (var segment in segments) {
      final sweepAngle = 2 * math.pi * segment.percentage;

      // Draw segment
      final segmentPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = segment.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        segmentPaint,
      );

      // Draw inner white circle to create donut chart
      final innerPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.white;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweepAngle,
        true,
        innerPaint,
      );

      // Calculate position for label if segment is large enough
      if (segment.percentage >= 0.1) {
        final labelAngle = startAngle + (sweepAngle / 2);
        final labelRadius = (innerRadius + outerRadius) / 2;
        final labelX = center.dx + labelRadius * math.cos(labelAngle);
        final labelY = center.dy + labelRadius * math.sin(labelAngle);

        final textSpan = TextSpan(
          text: '${(segment.percentage * 100).toInt()}%',
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
    }

    // Draw center circle
    final centerPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white;

    canvas.drawCircle(center, innerRadius, centerPaint);

    // Draw center text
    final textSpan = TextSpan(
      text: centerText,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.2,
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
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
