import 'package:flutter/material.dart';
import 'dart:math' as math;

class TrendChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final double height;
  final bool showLabels;
  final bool showGradient;
  final bool animate;

  const TrendChart({
    Key? key,
    required this.dataPoints,
    this.lineColor = Colors.blue,
    this.fillColor = Colors.blue,
    this.height = 80,
    this.showLabels = false,
    this.showGradient = true,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendChartPainter(
          dataPoints: dataPoints,
          lineColor: lineColor,
          fillColor: fillColor,
          showGradient: showGradient,
          animate: animate,
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final bool showGradient;
  final bool animate;
  final double animationValue;

  _TrendChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
    required this.showGradient,
    required this.animate,
  }) : animationValue = animate ? 1.0 : 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final double width = size.width;
    final double height = size.height;
    final double stepX = width / (dataPoints.length - 1);

    // Find min and max to scale the data
    double maxValue = dataPoints.reduce(math.max);
    double minValue = dataPoints.reduce(math.min);
    if (maxValue == minValue) {
      // Handle flat data
      maxValue += 0.1;
      minValue -= 0.1;
    }

    final path = Path();
    final points = <Offset>[];

    // Calculate how many points to draw based on animation
    final pointsToDraw =
        animate
            ? (dataPoints.length * animationValue).ceil()
            : dataPoints.length;

    // Start the path at the bottom left
    path.moveTo(0, height);

    // Draw the path through all data points
    for (int i = 0; i < pointsToDraw; i++) {
      final double x = i * stepX;
      final double normalizedValue =
          (dataPoints[i] - minValue) / (maxValue - minValue);
      final double y = height - (normalizedValue * height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      points.add(Offset(x, y));
    }

    // Complete the path to the bottom right
    if (pointsToDraw > 0) {
      path.lineTo(points.last.dx, height);
      path.lineTo(0, height);
      path.close();
    }

    // Draw the fill with gradient
    if (showGradient) {
      final Paint fillPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [fillColor.withOpacity(0.5), fillColor.withOpacity(0.1)],
            ).createShader(Rect.fromLTWH(0, 0, width, height));

      canvas.drawPath(path, fillPaint);
    }

    // Draw the line
    final Paint linePaint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Create a path just for the line (not closed)
    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
      } else {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(linePath, linePaint);

    // Draw points
    final Paint pointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final Paint pointBorderPaint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Draw only a few key points to avoid clutter
    for (int i = 0; i < points.length; i++) {
      if (i == 0 || i == points.length - 1 || i % 3 == 0) {
        canvas.drawCircle(points[i], 4, pointPaint);
        canvas.drawCircle(points[i], 4, pointBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dataPoints != dataPoints;
  }
}

class MultiTrendChart extends StatelessWidget {
  final Map<String, List<double>> dataSeries;
  final Map<String, Color> colors;
  final double height;
  final bool showLegend;
  final bool animate;

  const MultiTrendChart({
    Key? key,
    required this.dataSeries,
    required this.colors,
    this.height = 200,
    this.showLegend = true,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _MultiTrendChartPainter(
              dataSeries: dataSeries,
              colors: colors,
              animate: animate,
            ),
          ),
        ),
        if (showLegend) ...[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                dataSeries.keys.map((key) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[key],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(key, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}

class _MultiTrendChartPainter extends CustomPainter {
  final Map<String, List<double>> dataSeries;
  final Map<String, Color> colors;
  final bool animate;
  final double animationValue;

  _MultiTrendChartPainter({
    required this.dataSeries,
    required this.colors,
    required this.animate,
  }) : animationValue = animate ? 1.0 : 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataSeries.isEmpty) return;

    final double width = size.width;
    final double height = size.height;

    // Find the maximum number of data points across all series
    int maxDataPoints = 0;
    dataSeries.values.forEach((points) {
      if (points.length > maxDataPoints) {
        maxDataPoints = points.length;
      }
    });

    if (maxDataPoints == 0) return;

    // Find global min and max to scale all series consistently
    double globalMax = double.negativeInfinity;
    double globalMin = double.infinity;
    dataSeries.values.forEach((points) {
      if (points.isNotEmpty) {
        final localMax = points.reduce(math.max);
        final localMin = points.reduce(math.min);
        if (localMax > globalMax) globalMax = localMax;
        if (localMin < globalMin) globalMin = localMin;
      }
    });

    if (globalMax == globalMin) {
      // Handle flat data
      globalMax += 0.1;
      globalMin -= 0.1;
    }

    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Horizontal grid lines
    final int gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Draw each data series
    dataSeries.forEach((key, points) {
      if (points.isEmpty) return;

      final stepX = width / (points.length - 1);
      final linePath = Path();
      final linePoints = <Offset>[];

      // Calculate points
      for (int i = 0; i < points.length; i++) {
        final double x = i * stepX;
        final double normalizedValue =
            (points[i] - globalMin) / (globalMax - globalMin);
        final double y = height - (normalizedValue * height);

        if (i == 0) {
          linePath.moveTo(x, y);
        } else {
          linePath.lineTo(x, y);
        }

        linePoints.add(Offset(x, y));
      }

      // Draw the line
      final linePaint =
          Paint()
            ..color = colors[key] ?? Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(linePath, linePaint);

      // Draw key points
      final pointPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      final pointBorderPaint =
          Paint()
            ..color = colors[key] ?? Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      // Draw a few key points
      int step = math.max((points.length / 10).round(), 1);
      for (int i = 0; i < linePoints.length; i += step) {
        if (i == 0 || i == linePoints.length - 1 || i % step == 0) {
          canvas.drawCircle(linePoints[i], 3, pointPaint);
          canvas.drawCircle(linePoints[i], 3, pointBorderPaint);
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant _MultiTrendChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dataSeries != dataSeries;
  }
}
