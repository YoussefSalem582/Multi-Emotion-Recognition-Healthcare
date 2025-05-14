import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A chart widget for displaying multiple emotion trends
class MultiTrendChart extends StatelessWidget {
  final Map<String, List<double>> dataSeries;
  final Map<String, Color> colors;
  final double height;
  final bool showLegend;

  const MultiTrendChart({
    Key? key,
    required this.dataSeries,
    required this.colors,
    this.height = 200,
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLegend) _buildLegend(),
        SizedBox(height: showLegend ? 16 : 0),
        Container(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _MultiTrendChartPainter(
              dataSeries: dataSeries,
              colors: colors,
            ),
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
          dataSeries.keys.map((name) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[name] ?? Colors.grey,
                  ),
                ),
                SizedBox(width: 4),
                Text(name),
              ],
            );
          }).toList(),
    );
  }
}

class _MultiTrendChartPainter extends CustomPainter {
  final Map<String, List<double>> dataSeries;
  final Map<String, Color> colors;

  _MultiTrendChartPainter({required this.dataSeries, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background grid
    _drawBackgroundGrid(canvas, size);

    // Draw trend lines
    dataSeries.forEach((name, values) {
      _drawTrendLine(canvas, size, values, colors[name] ?? Colors.grey);
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

    // Get the maximum number of data points from all series
    int maxDataPoints = 0;
    dataSeries.values.forEach((series) {
      if (series.length > maxDataPoints) {
        maxDataPoints = series.length;
      }
    });

    // Draw vertical lines
    for (int i = 0; i < maxDataPoints; i++) {
      final x = i * size.width / (maxDataPoints - 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawTrendLine(
    Canvas canvas,
    Size size,
    List<double> values,
    Color color,
  ) {
    if (values.isEmpty) return;

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
