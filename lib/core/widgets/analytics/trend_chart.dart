import 'package:flutter/material.dart';
import '../../../models/analytics_data.dart';

/// A chart widget for displaying emotion trends
class TrendChart extends StatelessWidget {
  final Map<String, List<double>> trends;
  final Map<String, Color> colors;
  final bool showLegend;

  const TrendChart({
    Key? key,
    required this.trends,
    required this.colors,
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLegend) _buildLegend(),
        SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          child: CustomPaint(
            painter: _TrendChartPainter(trends: trends, colors: colors),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          trends.keys.map((emotion) {
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
                Text(emotion),
              ],
            );
          }).toList(),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final Map<String, List<double>> trends;
  final Map<String, Color> colors;

  _TrendChartPainter({required this.trends, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background grid
    _drawBackgroundGrid(canvas, size);

    // Draw trend lines
    trends.forEach((emotion, values) {
      _drawTrendLine(canvas, size, values, colors[emotion] ?? Colors.grey);
    });
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 1;

    // Draw horizontal lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (i * size.height / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    final numPoints = trends.values.first.length;
    for (int i = 0; i < numPoints; i++) {
      final x = i * size.width / (numPoints - 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawTrendLine(
    Canvas canvas,
    Size size,
    List<double> values,
    Color color,
  ) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = size.height - (values[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = size.height - (values[i] * size.height);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
