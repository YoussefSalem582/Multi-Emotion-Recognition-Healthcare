import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

/// A container widget that prevents overflow issues by providing proper constraints
/// to its children based on available space.
class SafeAreaContainer extends StatelessWidget {
  /// The child widget to be contained
  final Widget child;

  /// Optional fixed width of the container
  final double? width;

  /// Optional fixed height of the container
  final double? height;

  /// Minimum width constraint
  final double minWidth;

  /// Maximum width constraint
  final double maxWidth;

  /// Minimum height constraint
  final double minHeight;

  /// Maximum height constraint
  final double maxHeight;

  /// Internal padding
  final EdgeInsetsGeometry padding;

  /// External margin
  final EdgeInsetsGeometry margin;

  /// Whether to add horizontal scrolling when content overflows
  final bool enableHorizontalScroll;

  /// Whether to add vertical scrolling when content overflows
  final bool enableVerticalScroll;

  /// Background color
  final Color? backgroundColor;

  /// Decoration for the container
  final BoxDecoration? decoration;

  /// Alignment of the child within the container
  final Alignment alignment;

  /// Create a safe area container with proper constraints
  const SafeAreaContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.minHeight = 0,
    this.maxHeight = double.infinity,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.enableHorizontalScroll = false,
    this.enableVerticalScroll = false,
    this.backgroundColor,
    this.decoration,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: child);

    // Apply scrolling if needed
    if (enableHorizontalScroll && enableVerticalScroll) {
      content = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: content,
        ),
      );
    } else if (enableHorizontalScroll) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: content,
      );
    } else if (enableVerticalScroll) {
      content = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: content,
      );
    }

    return SafeArea(
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
        margin: margin,
        decoration: decoration,
        color: backgroundColor,
        alignment: alignment,
        child: content,
      ),
    );
  }

  /// Create a container specifically for chart widgets
  factory SafeAreaContainer.forChart({
    required Widget child,
    double? height = 220,
    double minHeight = 150,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    bool enableHorizontalScroll = true,
  }) {
    return SafeAreaContainer(
      height: height,
      minHeight: minHeight,
      padding: padding,
      enableHorizontalScroll: enableHorizontalScroll,
      child: child,
    );
  }

  /// Create a container for text content that handles overflow gracefully
  factory SafeAreaContainer.forText({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 4.0),
    bool enableHorizontalScroll = true,
  }) {
    return SafeAreaContainer(
      padding: padding,
      enableHorizontalScroll: enableHorizontalScroll,
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  /// Create a container that adapts its width based on screen size
  factory SafeAreaContainer.responsive({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double smallScreenPadding = 8.0,
    double largeScreenPadding = 16.0,
  }) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return SafeAreaContainer(
      padding:
          padding ??
          EdgeInsets.all(
            isSmallScreen ? smallScreenPadding : largeScreenPadding,
          ),
      maxWidth: isSmallScreen ? double.infinity : 600,
      child: child,
    );
  }
}
