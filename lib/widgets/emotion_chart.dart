import 'package:flutter/material.dart';
import 'dart:math' as math;

class EmotionChart extends StatelessWidget {
  final Map<String, double> emotionData;
  final double height;
  final double width;
  final bool showLabels;
  final bool animated;

  const EmotionChart({
    Key? key,
    required this.emotionData,
    this.height = 200,
    this.width = 200,
    this.showLabels = true,
    this.animated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          child: CustomPaint(
            painter: _EmotionChartPainter(
              emotionData: emotionData,
              context: context,
              animated: animated,
            ),
          ),
        ),
        if (showLabels) ...[
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                emotionData.entries.map((entry) {
                  final color = _getEmotionColor(entry.key);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${entry.key} (${(entry.value * 100).toInt()}%)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      case 'Surprised':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }
}

class _EmotionChartPainter extends CustomPainter {
  final Map<String, double> emotionData;
  final BuildContext context;
  final bool animated;

  _EmotionChartPainter({
    required this.emotionData,
    required this.context,
    required this.animated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2; // Start from top

    emotionData.forEach((emotion, value) {
      final sweepAngle = 2 * math.pi * value;
      final color = _getEmotionColor(emotion);

      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = color;

      // Draw pie segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw segment border
      final borderPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.white
            ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Calculate position for label
      if (value >= 0.1) {
        // Only draw labels for segments that are large enough
        final labelAngle = startAngle + (sweepAngle / 2);
        final labelRadius = radius * 0.7; // Place label at 70% of the radius
        final labelX = center.dx + labelRadius * math.cos(labelAngle);
        final labelY = center.dy + labelRadius * math.sin(labelAngle);

        final textSpan = TextSpan(
          text: '${(value * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
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

    // Draw center circle for donut chart effect
    final centerCirclePaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Theme.of(context).colorScheme.surface;

    canvas.drawCircle(center, radius * 0.5, centerCirclePaint);

    // Draw border for center circle
    final centerBorderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Theme.of(context).colorScheme.outlineVariant
          ..strokeWidth = 1;

    canvas.drawCircle(center, radius * 0.5, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      case 'Surprised':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }
}

class EmotionBarChart extends StatelessWidget {
  final Map<String, double> emotionData;
  final bool showPercentage;

  const EmotionBarChart({
    Key? key,
    required this.emotionData,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedEntries =
        emotionData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          sortedEntries.map((entry) {
            final color = _getEmotionColor(entry.key);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      if (showPercentage)
                        Text('${(entry.value * 100).toInt()}%'),
                    ],
                  ),
                  SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0, end: entry.value),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      case 'Surprised':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }
}
