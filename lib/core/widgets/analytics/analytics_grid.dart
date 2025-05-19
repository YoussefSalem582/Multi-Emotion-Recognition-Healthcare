import 'package:flutter/material.dart';
import '../../../models/analytics_data.dart';
import 'analytics_card.dart';

/// A grid of analytics cards
class AnalyticsGrid extends StatelessWidget {
  final List<AnalyticsData> items;
  final int crossAxisCount;
  final double spacing;

  const AnalyticsGrid({
    Key? key,
    required this.items,
    this.crossAxisCount = 2,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return AnalyticsCard(
          data: items[index],
          isCompact: true,
          onTap: () {
            // Handle analytics card tap
          },
        );
      },
    );
  }
}
