import 'package:flutter/material.dart';
import '../../utils/overflow_helper.dart';
import '../../utils/responsive_helper.dart';

/// A widget that prevents RenderFlex overflow warnings by properly constraining its child
///
/// This widget is useful when you have UI components that might overflow their container
/// and trigger yellow-black warning banners in debug mode.
class OverflowWarningFixer extends StatelessWidget {
  /// The child widget that might cause overflow issues
  final Widget child;

  /// The axis along which the child should be constrained (horizontal or vertical)
  final Axis axis;

  /// Whether to show a visual placeholder if there's no space
  final bool showPlaceholder;

  /// Color for the placeholder indicator
  final Color? placeholderColor;

  /// Create an overflow warning fixer widget
  const OverflowWarningFixer({
    Key? key,
    required this.child,
    this.axis = Axis.horizontal,
    this.showPlaceholder = false,
    this.placeholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If there's virtually no space, show a placeholder or empty container
        if ((axis == Axis.horizontal && constraints.maxWidth < 10) ||
            (axis == Axis.vertical && constraints.maxHeight < 10)) {
          if (showPlaceholder) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: placeholderColor ?? Colors.amber.withOpacity(0.2),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        // Wrap with a flexible container for horizontal or vertical overflow
        return axis == Axis.horizontal
            ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            )
            : SingleChildScrollView(child: child);
      },
    );
  }

  /// Creates a fixer specifically for horizontal charts
  factory OverflowWarningFixer.forChart({
    required Widget child,
    double? height = 220,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  }) {
    return OverflowWarningFixer(
      child: child,
      axis: Axis.horizontal,
      showPlaceholder: true,
    );
  }

  /// Creates a fixer for data lists that might overflow vertically
  factory OverflowWarningFixer.forList({
    required Widget child,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 8.0),
  }) {
    return OverflowWarningFixer(
      child: child,
      axis: Axis.vertical,
      showPlaceholder: true,
    );
  }

  /// Creates a fixer for the emotion chart screen
  factory OverflowWarningFixer.forEmotionChart({
    required Widget child,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  }) {
    return OverflowWarningFixer(
      child: child,
      axis: Axis.vertical,
      showPlaceholder: true,
    );
  }
}
