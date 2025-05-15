import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

/// A wrapper widget that makes its child responsive to the screen size
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final bool clipBehavior;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.clipBehavior = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Apply responsive behavior
        final width = constraints.maxWidth;

        // Return a container with proper constraints
        return Container(
          clipBehavior: clipBehavior ? Clip.hardEdge : Clip.none,
          padding: ResponsiveHelper.getScreenPadding(context),
          child: child,
        );
      },
    );
  }
}

/// A grid that adapts to the screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? forceColumns;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.forceColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount =
            forceColumns ?? ResponsiveHelper.getGridColumnCount(context);

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: ResponsiveHelper.getGridAspectRatio(context),
          ),
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// A row that switches to a column on small screens
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final double spacing;

  const ResponsiveRowColumn({
    Key? key,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useColumn =
        MediaQuery.of(context).size.width < ResponsiveHelper.mediumScreenSize;

    if (useColumn) {
      return Column(
        mainAxisAlignment: columnMainAxisAlignment,
        crossAxisAlignment: columnCrossAxisAlignment,
        children: _addSpacing(children, isColumn: true),
      );
    }

    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      children: _addSpacing(children, isColumn: false),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, {required bool isColumn}) {
    if (widgets.length <= 1) return widgets;

    final result = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);

      if (i < widgets.length - 1) {
        if (isColumn) {
          result.add(SizedBox(height: spacing));
        } else {
          result.add(SizedBox(width: spacing));
        }
      }
    }

    return result;
  }
}
