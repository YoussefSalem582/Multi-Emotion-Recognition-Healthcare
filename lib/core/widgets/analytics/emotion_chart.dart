import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../common/safe_area_container.dart';

/// A pie chart widget for displaying emotion data
class EmotionChart extends StatelessWidget {
  final Map<String, double> emotions;
  final Map<String, Color>? colors;
  final double size;
  final bool showOverflowWarning;

  const EmotionChart({
    Key? key,
    required this.emotions,
    this.colors,
    this.size = 150,
    this.showOverflowWarning = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size to determine constraints
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    // Calculate appropriate chart size
    final chartSize = isSmallScreen ? math.min(size, 120.0) : size;

    // Calculate total value for percentage
    final double total = emotions.values.fold(0, (sum, val) => sum + val);

    return SafeAreaContainer(
      width: chartSize,
      height: chartSize,
      child: Stack(
        children: [
          // Pie chart
          CustomPaint(
            size: Size(chartSize, chartSize),
            painter: _EmotionPieChartPainter(
              emotions: emotions,
              colors: colors,
              total: total,
            ),
          ),

          // Overflow warning if enabled
          if (showOverflowWarning)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                color: Colors.amber.withOpacity(0.8),
                child: Center(
                  child: Text(
                    'BOTTOM OVERFLOWED BY 41 PIXELS',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmotionPieChartPainter extends CustomPainter {
  final Map<String, double> emotions;
  final Map<String, Color>? colors;
  final double total;

  _EmotionPieChartPainter({
    required this.emotions,
    this.colors,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate center and radius
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Sort emotions by value, highest first
    final sortedEmotions =
        emotions.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Draw pie chart
    double startAngle = -math.pi / 2; // Start from top

    for (var emotion in sortedEmotions) {
      final sweepAngle = 2 * math.pi * (emotion.value / total);

      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = _getColorForEmotion(emotion.key);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle (optional)
    canvas.drawCircle(center, radius * 0.5, Paint()..color = Colors.white);
  }

  Color _getColorForEmotion(String emotion) {
    if (colors != null && colors!.containsKey(emotion)) {
      return colors![emotion]!;
    }

    // Default colors from AppColors
    switch (emotion.toLowerCase()) {
      case 'happy':
        return AppColors.emotionHappy;
      case 'sad':
        return AppColors.emotionSad;
      case 'angry':
        return AppColors.emotionAngry;
      case 'fearful':
      case 'fear':
        return AppColors.emotionFearful;
      case 'surprised':
      case 'surprise':
        return AppColors.emotionSurprised;
      case 'disgusted':
      case 'disgust':
        return AppColors.emotionDisgusted;
      case 'neutral':
        return AppColors.emotionNeutral;
      case 'frustrated':
        return AppColors.orange;
      case 'confused':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
