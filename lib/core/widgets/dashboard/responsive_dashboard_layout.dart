import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../common/overflow_warning_fixer.dart';
import '../common/safe_area_container.dart';

/// A responsive layout wrapper for dashboard content that helps prevent overflow
class ResponsiveDashboardLayout extends StatelessWidget {
  /// The main content of the dashboard
  final Widget child;

  /// Whether to automatically add padding around the content
  final bool addPadding;

  /// Custom padding to apply (if addPadding is true)
  final EdgeInsetsGeometry? customPadding;

  /// Creates a responsive layout for dashboard content
  const ResponsiveDashboardLayout({
    Key? key,
    required this.child,
    this.addPadding = true,
    this.customPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size to determine appropriate padding
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final isExtraSmallScreen = ResponsiveHelper.isExtraSmallScreen(context);

    // Calculate appropriate padding based on screen size
    final padding =
        customPadding ??
        EdgeInsets.all(
          isExtraSmallScreen ? 8.0 : (isSmallScreen ? 12.0 : 16.0),
        );

    // Apply padding if requested
    final content =
        addPadding ? Padding(padding: padding, child: child) : child;

    // Wrap in a SingleChildScrollView to enable vertical scrolling
    return SafeAreaContainer(enableVerticalScroll: true, child: content);
  }

  /// Creates a layout specifically for chart sections
  factory ResponsiveDashboardLayout.forChartSection({
    required Widget title,
    required Widget chart,
    EdgeInsetsGeometry? padding,
    bool enableScrolling = true,
  }) {
    return ResponsiveDashboardLayout(
      addPadding: padding != null,
      customPadding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: 12),
          OverflowWarningFixer.forChart(child: chart),
        ],
      ),
    );
  }

  /// Creates a layout specifically for card grids
  factory ResponsiveDashboardLayout.forCardGrid({
    required List<Widget> cards,
    Widget? header,
    int? columnCount,
    double spacing = 12.0,
    EdgeInsetsGeometry? padding,
  }) {
    return ResponsiveDashboardLayout(
      addPadding: padding != null,
      customPadding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[header, SizedBox(height: 12)],
          Builder(
            builder: (context) {
              // Determine column count based on screen size if not specified
              final cols =
                  columnCount ?? ResponsiveHelper.getGridColumnCount(context);

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: ResponsiveHelper.getGridAspectRatio(
                    context,
                  ),
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) => cards[index],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Creates a layout for a scrollable list of items
  factory ResponsiveDashboardLayout.forList({
    required List<Widget> items,
    Widget? header,
    double spacing = 8.0,
    EdgeInsetsGeometry? padding,
    double? maxHeight,
  }) {
    return ResponsiveDashboardLayout(
      addPadding: padding != null,
      customPadding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[header, SizedBox(height: 12)],
          OverflowWarningFixer.forList(
            height: maxHeight,
            child: Column(
              children: List.generate(items.length * 2 - 1, (index) {
                if (index.isEven) {
                  return items[index ~/ 2];
                } else {
                  return SizedBox(height: spacing);
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
