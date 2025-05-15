import 'package:flutter/material.dart';
import 'responsive_helper.dart';

/// Helper class to prevent overflow issues in the UI
class OverflowHelper {
  /// Creates a container that handles overflow with proper constraints for charts
  static Widget createChartContainer({
    required Widget child,
    double? height,
    double minHeight = 150,
    double horizontalPadding = 8.0,
    bool addScrolling = false,
  }) {
    final Widget content =
        addScrolling
            ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(height: height, child: child),
            )
            : SizedBox(height: height, child: child);

    return Container(
      constraints: BoxConstraints(
        minHeight: minHeight,
        maxHeight: height ?? double.infinity,
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: content,
    );
  }

  /// Creates a container that handles text overflow properly
  static Widget createTextContainer({
    required String text,
    required TextStyle style,
    TextAlign align = TextAlign.start,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 0, maxWidth: double.infinity),
      child: Text(
        text,
        style: style,
        textAlign: align,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  /// Creates a flexible row that won't overflow
  static Widget createFlexibleRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 8.0,
    bool wrapOnOverflow = false,
  }) {
    if (wrapOnOverflow) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addSpacers(children, spacing),
    );
  }

  /// Creates a row that adapts to available space or wraps to multiple rows
  static Widget createResponsiveRow({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 8.0,
    double runSpacing = 8.0,
    WrapAlignment alignment = WrapAlignment.start,
  }) {
    // Get screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    // On smaller screens, always wrap
    if (isSmallScreen) {
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        children: children,
      );
    }

    // On larger screens, try to fit in one row with Flexible children
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children.map((child) => Flexible(child: child)).toList(),
    );
  }

  /// Creates a card with proper constraints that won't overflow
  static Widget createConstrainedCard({
    required Widget child,
    double? width,
    double? height,
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    Color? color,
    double elevation = 2.0,
  }) {
    return Card(
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
        padding: padding,
        child: child,
      ),
    );
  }

  /// Creates a scrollable container for potentially overflowing content
  static Widget createScrollableContent({
    required Widget child,
    double? maxHeight,
    bool enableHorizontalScrolling = false,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight ?? double.infinity),
      child:
          enableHorizontalScrolling
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(child: child),
              )
              : SingleChildScrollView(child: child),
    );
  }

  /// Handles long text by truncating or scrolling
  static Widget handleLongText({
    required String text,
    required TextStyle style,
    int maxLines = 1,
    bool enableScroll = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    if (enableScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Text(text, style: style, textAlign: textAlign),
      );
    }

    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Adds spacers between widgets in a list
  static List<Widget> _addSpacers(List<Widget> widgets, double spacing) {
    final result = <Widget>[];

    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);

      if (i < widgets.length - 1) {
        result.add(SizedBox(width: spacing));
      }
    }

    return result;
  }
}
