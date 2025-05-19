import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/responsive_helper.dart';
import '../common/overflow_warning_fixer.dart';

/// A chart that visualizes emotions detected over time in a video
class EmotionTimelineChart extends StatefulWidget {
  /// Emotion data organized by timestamp in milliseconds
  final Map<int, Map<String, double>> timelineData;

  /// Current playback position in milliseconds
  final int currentPosition;

  /// Total video duration in milliseconds
  final int totalDuration;

  /// List of emotion names to display
  final List<String> emotionNames;

  /// Map of colors for each emotion
  final Map<String, Color> emotionColors;

  /// Height of the chart
  final double height;

  /// Whether to show the current position indicator
  final bool showPositionIndicator;

  /// Callback when position on timeline is tapped
  final Function(int position)? onPositionTapped;

  /// Creates an emotion timeline chart
  const EmotionTimelineChart({
    Key? key,
    required this.timelineData,
    this.currentPosition = 0,
    required this.totalDuration,
    required this.emotionNames,
    required this.emotionColors,
    this.height = 200.0,
    this.showPositionIndicator = true,
    this.onPositionTapped,
  }) : super(key: key);

  @override
  State<EmotionTimelineChart> createState() => _EmotionTimelineChartState();
}

class _EmotionTimelineChartState extends State<EmotionTimelineChart> {
  /// Entry point in milliseconds
  late int _lastTapPosition;

  @override
  void initState() {
    super.initState();
    _lastTapPosition = widget.currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotion color legend
          _buildLegend(),

          SizedBox(height: 8),

          // Timeline chart
          Expanded(
            child: GestureDetector(
              onTapDown:
                  widget.onPositionTapped != null ? _handleTimelineTap : null,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _EmotionTimelinePainter(
                      timelineData: widget.timelineData,
                      currentPosition: widget.currentPosition,
                      totalDuration: widget.totalDuration,
                      emotionNames: widget.emotionNames,
                      emotionColors: widget.emotionColors,
                      showPositionIndicator: widget.showPositionIndicator,
                      lastTapPosition: _lastTapPosition,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // Time markers
          _buildTimeMarkers(),
        ],
      ),
    );
  }

  /// Build color legend for emotions
  Widget _buildLegend() {
    return OverflowWarningFixer(
      axis: Axis.horizontal,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children:
            widget.emotionNames.map((emotion) {
              final color = widget.emotionColors[emotion] ?? Colors.grey;
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
                    emotion,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  /// Build time markers at regular intervals
  Widget _buildTimeMarkers() {
    // Calculate intervals based on total duration
    final intervals = _calculateTimeIntervals();

    return OverflowWarningFixer(
      axis: Axis.horizontal,
      child: Container(
        height: 24,
        child: Stack(
          children: List.generate(intervals.length, (index) {
            final position = intervals[index];
            final percentage = position / widget.totalDuration;

            return Positioned(
              left:
                  percentage *
                  (MediaQuery.of(context).size.width -
                      32), // Accounting for padding
              child: Text(
                _formatDuration(Duration(milliseconds: position)),
                style: TextStyle(fontSize: 10),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Calculate appropriate time intervals
  List<int> _calculateTimeIntervals() {
    final isSmall = ResponsiveHelper.isSmallScreen(context);
    final totalSeconds = widget.totalDuration ~/ 1000;

    // Determine the appropriate interval
    int intervalSeconds;
    if (totalSeconds <= 30) {
      intervalSeconds = isSmall ? 10 : 5;
    } else if (totalSeconds <= 60) {
      intervalSeconds = isSmall ? 15 : 10;
    } else if (totalSeconds <= 300) {
      // 5 minutes
      intervalSeconds = isSmall ? 60 : 30;
    } else {
      intervalSeconds = isSmall ? 120 : 60;
    }

    // Generate time intervals
    final List<int> intervals = [];
    for (int t = 0; t <= totalSeconds; t += intervalSeconds) {
      intervals.add(t * 1000); // Convert back to milliseconds
    }

    // Always include the end position
    if (!intervals.contains(widget.totalDuration)) {
      intervals.add(widget.totalDuration);
    }

    return intervals;
  }

  /// Format duration as MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Handle tap on timeline to seek
  void _handleTimelineTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double width = renderBox.size.width;
    final double tapPosition = details.localPosition.dx;
    final double percentage = tapPosition / width;

    // Calculate milliseconds position
    final int position = (percentage * widget.totalDuration).round();

    // Update last tap position
    setState(() {
      _lastTapPosition = position;
    });

    // Callback
    if (widget.onPositionTapped != null) {
      widget.onPositionTapped!(position);
    }
  }
}

/// Custom painter for emotion timeline visualization
class _EmotionTimelinePainter extends CustomPainter {
  final Map<int, Map<String, double>> timelineData;
  final int currentPosition;
  final int totalDuration;
  final List<String> emotionNames;
  final Map<String, Color> emotionColors;
  final bool showPositionIndicator;
  final int lastTapPosition;

  _EmotionTimelinePainter({
    required this.timelineData,
    required this.currentPosition,
    required this.totalDuration,
    required this.emotionNames,
    required this.emotionColors,
    required this.showPositionIndicator,
    required this.lastTapPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Set up paints
    final Paint linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;

    final Paint currentPositionPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final Paint tapPositionPaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Draw background grid
    _drawGrid(canvas, size);

    // Get sorted timestamps
    final List<int> timestamps = timelineData.keys.toList()..sort();

    if (timestamps.isEmpty) return;

    // Draw emotion lines
    for (final emotion in emotionNames) {
      final Color color = emotionColors[emotion] ?? Colors.grey;
      linePaint.color = color;
      fillPaint.color = color.withOpacity(0.2);

      _drawEmotionLine(canvas, size, emotion, timestamps, linePaint, fillPaint);
    }

    // Draw current position indicator
    if (showPositionIndicator && currentPosition > 0) {
      final double x = (currentPosition / totalDuration) * size.width;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        currentPositionPaint,
      );
    }

    // Draw tap position indicator
    if (lastTapPosition > 0 && lastTapPosition != currentPosition) {
      final double x = (lastTapPosition / totalDuration) * size.width;

      // Draw dashed line
      final dashLength = 5.0;
      final gapLength = 3.0;
      double currentY = 0;

      while (currentY < size.height) {
        canvas.drawLine(
          Offset(x, currentY),
          Offset(x, math.min(currentY + dashLength, size.height)),
          tapPositionPaint,
        );
        currentY += dashLength + gapLength;
      }
    }
  }

  /// Draw background grid
  void _drawGrid(Canvas canvas, Size size) {
    final Paint gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    // Horizontal grid lines
    final int horizontalLines = 4;
    final double horizontalSpacing = size.height / horizontalLines;

    for (int i = 1; i < horizontalLines; i++) {
      final double y = i * horizontalSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines (time markers)
    final int verticalLines = 10;
    final double verticalSpacing = size.width / verticalLines;

    for (int i = 1; i < verticalLines; i++) {
      final double x = i * verticalSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  /// Draw emotion line and fill
  void _drawEmotionLine(
    Canvas canvas,
    Size size,
    String emotion,
    List<int> timestamps,
    Paint linePaint,
    Paint fillPaint,
  ) {
    if (timestamps.isEmpty) return;

    // Create path for line
    final Path linePath = Path();
    final Path fillPath = Path();

    // Start with the first data point
    double startX = (timestamps.first / totalDuration) * size.width;
    double startY =
        size.height -
        ((timelineData[timestamps.first]?[emotion] ?? 0) * size.height);

    linePath.moveTo(startX, startY);
    fillPath.moveTo(startX, size.height);
    fillPath.lineTo(startX, startY);

    // Draw the line through each data point
    for (int i = 1; i < timestamps.length; i++) {
      final timestamp = timestamps[i];
      final double x = (timestamp / totalDuration) * size.width;
      final double y =
          size.height -
          ((timelineData[timestamp]?[emotion] ?? 0) * size.height);

      linePath.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Close the fill path
    final double endX = (timestamps.last / totalDuration) * size.width;
    fillPath.lineTo(endX, size.height);
    fillPath.close();

    // Draw the fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(_EmotionTimelinePainter oldDelegate) {
    return oldDelegate.currentPosition != currentPosition ||
        oldDelegate.lastTapPosition != lastTapPosition ||
        oldDelegate.timelineData != timelineData;
  }
}
