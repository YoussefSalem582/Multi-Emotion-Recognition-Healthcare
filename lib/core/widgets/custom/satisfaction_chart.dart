import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/customer_satisfaction.dart';

class SatisfactionChart extends StatelessWidget {
  final Map<String, int> scoreDistribution;
  final Map<String, double>? categoryAverages;
  final bool showLegend;
  final bool animateChart;
  final double height;
  final double barRadius;

  const SatisfactionChart({
    Key? key,
    required this.scoreDistribution,
    this.categoryAverages,
    this.showLegend = true,
    this.animateChart = true,
    this.height = 240,
    this.barRadius = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height, child: _buildChart(context)),
        if (showLegend) _buildLegend(context),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    // Check if any data exists
    final total = scoreDistribution.values.fold(0, (sum, value) => sum + value);
    if (total == 0) {
      return Center(
        child: Text('No data available', style: TextStyle(color: Colors.grey)),
      );
    }

    return categoryAverages != null
        ? _buildCategoryChart(context)
        : _buildScoreChart(context);
  }

  Widget _buildScoreChart(BuildContext context) {
    // Find the highest value for scaling
    final maxValue = scoreDistribution.values.fold(
      0,
      (max, value) => value > max ? value : max,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 1; i <= 5; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Label for value
                  Text(
                    '${scoreDistribution[i.toString()] ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _getColorForScore(i.toDouble()),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Bar
                  AnimatedContainer(
                    duration:
                        animateChart
                            ? const Duration(milliseconds: 500)
                            : Duration.zero,
                    curve: Curves.easeInOut,
                    height:
                        maxValue > 0
                            ? (scoreDistribution[i.toString()] ?? 0) /
                                maxValue *
                                (height - 60) // Adjust for labels
                            : 0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getColorForScore(i.toDouble()),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(barRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getColorForScore(
                            i.toDouble(),
                          ).withOpacity(0.3),
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label for score
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getColorForScore(i.toDouble()).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      i.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChart(BuildContext context) {
    if (categoryAverages == null || categoryAverages!.isEmpty) {
      return Center(
        child: Text(
          'No category data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: categoryAverages!.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (context, index) {
        final entry = categoryAverages!.entries.elementAt(index);
        final categoryName = entry.key;
        final averageScore = entry.value;
        final color = _getColorForScore(averageScore);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      categoryName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      averageScore.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  // Background
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(barRadius),
                    ),
                  ),
                  // Value
                  AnimatedContainer(
                    duration:
                        animateChart
                            ? const Duration(milliseconds: 500)
                            : Duration.zero,
                    curve: Curves.easeInOut,
                    height: 12,
                    width:
                        MediaQuery.of(context).size.width *
                        0.8 *
                        (averageScore / 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(barRadius),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildLegendItem(
            context,
            color: _getColorForScore(1.0),
            label: 'Very Dissatisfied',
          ),
          _buildLegendItem(
            context,
            color: _getColorForScore(2.0),
            label: 'Dissatisfied',
          ),
          _buildLegendItem(
            context,
            color: _getColorForScore(3.0),
            label: 'Neutral',
          ),
          _buildLegendItem(
            context,
            color: _getColorForScore(4.0),
            label: 'Satisfied',
          ),
          _buildLegendItem(
            context,
            color: _getColorForScore(5.0),
            label: 'Very Satisfied',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 4.5) return Colors.green[800]!;
    if (score >= 4.0) return Colors.green;
    if (score >= 3.5) return Colors.lightGreen;
    if (score >= 3.0) return Colors.amber;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }
}

// Pie chart for showing overall distribution
class SatisfactionPieChart extends StatelessWidget {
  final Map<String, int> scoreDistribution;
  final double size;
  final bool showLabels;
  final bool showLegend;

  const SatisfactionPieChart({
    Key? key,
    required this.scoreDistribution,
    this.size = 200,
    this.showLabels = true,
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total for percentages
    final total = scoreDistribution.values.fold(0, (sum, value) => sum + value);

    if (total == 0) {
      return SizedBox(
        height: size,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CustomPaint(
            painter: _PieChartPainter(
              scoreDistribution: scoreDistribution,
              showLabels: showLabels,
            ),
          ),
        ),
        if (showLegend)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                for (int i = 1; i <= 5; i++)
                  if (scoreDistribution[i.toString()] != null &&
                      scoreDistribution[i.toString()]! > 0)
                    _buildLegendItem(
                      context,
                      color: _getColorForScore(i.toDouble()),
                      label: '$i - ${_getSatisfactionLabel(i.toDouble())}',
                      percentage:
                          '${((scoreDistribution[i.toString()] ?? 0) / total * 100).toStringAsFixed(1)}%',
                    ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
    required String percentage,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label ($percentage)', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 4.5) return Colors.green[800]!;
    if (score >= 4.0) return Colors.green;
    if (score >= 3.5) return Colors.lightGreen;
    if (score >= 3.0) return Colors.amber;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }

  String _getSatisfactionLabel(double score) {
    if (score >= 4.5) return 'Very Satisfied';
    if (score >= 4.0) return 'Satisfied';
    if (score >= 3.0) return 'Neutral';
    if (score >= 2.0) return 'Dissatisfied';
    return 'Very Dissatisfied';
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, int> scoreDistribution;
  final bool showLabels;

  _PieChartPainter({required this.scoreDistribution, this.showLabels = true});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Calculate total for percentages
    final total = scoreDistribution.values.fold(0, (sum, value) => sum + value);
    if (total == 0) return;

    double startAngle = -pi / 2; // Start at top

    // Draw pie segments
    for (int i = 1; i <= 5; i++) {
      final value = scoreDistribution[i.toString()] ?? 0;
      if (value <= 0) continue;

      final sweepAngle = 2 * pi * value / total;
      final midAngle = startAngle + sweepAngle / 2;

      // Draw segment
      final paint =
          Paint()
            ..color = _getColorForScore(i.toDouble())
            ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // Draw label if needed
      if (showLabels && value / total > 0.05) {
        final labelRadius = radius * 0.6;
        final labelX = center.dx + labelRadius * cos(midAngle);
        final labelY = center.dy + labelRadius * sin(midAngle);

        final textSpan = TextSpan(
          text: '$i',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
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

    // Draw center circle with total
    final centerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.35, centerPaint);

    // Draw total number
    final textSpan = TextSpan(
      text: total.toString(),
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Color _getColorForScore(double score) {
    if (score >= 4.5) return Colors.green[800]!;
    if (score >= 4.0) return Colors.green;
    if (score >= 3.5) return Colors.lightGreen;
    if (score >= 3.0) return Colors.amber;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }
}
