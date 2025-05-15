import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

/// A specialized container for history lists that prevents overflow
class HistoryListContainer extends StatelessWidget {
  /// The items to display in the history list
  final List<Widget> items;

  /// Title for the history list
  final String title;

  /// Spacing between list items
  final double spacing;

  /// Creates a container for history lists that won't overflow
  const HistoryListContainer({
    Key? key,
    required this.items,
    required this.title,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Make the list scrollable vertically
            Container(
              constraints: BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(children: _buildListWithSeparators()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build list with separators
  List<Widget> _buildListWithSeparators() {
    final result = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);

      if (i < items.length - 1) {
        result.add(SizedBox(height: spacing));
      }
    }

    return result;
  }
}
