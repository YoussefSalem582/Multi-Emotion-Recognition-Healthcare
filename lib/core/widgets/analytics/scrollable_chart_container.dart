import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../common/overflow_warning_fixer.dart';

/// A specialized container that makes charts scrollable to prevent overflow
class ScrollableChartContainer extends StatelessWidget {
  /// The chart widget to be wrapped
  final Widget child;

  /// Optional title widget to display above the chart
  final Widget? title;

  /// Optional description to display below the chart
  final Widget? description;

  /// Fixed height for the chart content
  final double? fixedHeight;

  /// Fixed width for the chart content
  final double? fixedWidth;

  /// Minimum width to ensure proper display
  final double minWidth;

  /// Additional padding around the chart
  final EdgeInsetsGeometry padding;

  /// Background color for the container
  final Color? backgroundColor;

  /// Border radius for the container
  final BorderRadius borderRadius;

  /// Whether to show a yellow warning banner (for debugging)
  final bool showWarningBanner;

  /// The warning message to display (if showWarningBanner is true)
  final String warningMessage;

  /// Creates a scrollable container for charts
  const ScrollableChartContainer({
    Key? key,
    required this.child,
    this.title,
    this.description,
    this.fixedHeight,
    this.fixedWidth,
    this.minWidth = 300.0,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.showWarningBanner = false,
    this.warningMessage = 'OVERFLOW WARNING',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we need to enable scrolling based on available width
        final availableWidth = constraints.maxWidth;
        final needsScrolling = availableWidth < minWidth;

        // Decide on container width
        final containerWidth = needsScrolling ? minWidth : availableWidth;

        // Build chart content
        Widget chartContent = child;

        // Add warning banner for debugging if requested
        if (showWarningBanner) {
          chartContent = Stack(
            children: [
              chartContent,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  color: Colors.amber.withOpacity(0.8),
                  child: Center(
                    child: Text(
                      warningMessage,
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
          );
        }

        // Create the chart container
        final container = Container(
          width: fixedWidth ?? containerWidth,
          height: fixedHeight,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).cardColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[title!, SizedBox(height: 16)],
              Expanded(child: chartContent),
              if (description != null) ...[SizedBox(height: 16), description!],
            ],
          ),
        );

        // Wrap in horizontal scroll if needed
        if (needsScrolling) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: container,
          );
        }

        return container;
      },
    );
  }

  /// Factory constructor for trend charts with common styling
  factory ScrollableChartContainer.forTrendChart({
    required Widget chart,
    required String title,
    String? subtitle,
    double? fixedHeight = 250.0,
  }) {
    return ScrollableChartContainer(
      fixedHeight: fixedHeight,
      minWidth: 400.0, // Most trend charts need more width
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ],
      ),
      child: chart,
    );
  }

  /// Factory constructor for emotion pie charts with common styling
  factory ScrollableChartContainer.forEmotionPieChart({
    required Widget chart,
    required String title,
    double? fixedHeight = 220.0,
  }) {
    return ScrollableChartContainer(
      fixedHeight: fixedHeight,
      minWidth: 280.0, // Pie charts need less width
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      child: chart,
    );
  }
}
