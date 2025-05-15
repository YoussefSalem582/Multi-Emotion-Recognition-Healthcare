import 'package:flutter/material.dart';
import '../../../models/analytics_data.dart';
import '../../utils/overflow_helper.dart';
import '../../utils/responsive_helper.dart';
import '../common/safe_area_container.dart';

/// A card widget for displaying analytics data
class AnalyticsCard extends StatelessWidget {
  final AnalyticsData data;
  final VoidCallback? onTap;
  final bool isCompact;

  const AnalyticsCard({
    Key? key,
    required this.data,
    this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine if we're on a small screen
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final isExtraSmallScreen = ResponsiveHelper.isExtraSmallScreen(context);

    // Adjust sizes based on screen size
    final double iconSize =
        isSmallScreen ? (isCompact ? 16.0 : 18.0) : (isCompact ? 20.0 : 24.0);
    final double titleFontSize =
        isSmallScreen ? (isCompact ? 11.0 : 12.0) : (isCompact ? 12.0 : 14.0);
    final double valueFontSize =
        isSmallScreen ? (isCompact ? 16.0 : 18.0) : (isCompact ? 18.0 : 24.0);
    final double trendFontSize = isSmallScreen ? 9.0 : 10.0;

    // Use OverflowHelper to create a card with proper constraints
    return OverflowHelper.createConstrainedCard(
      minHeight: isCompact ? 90.0 : 110.0,
      padding: EdgeInsets.all(
        isSmallScreen ? (isCompact ? 8.0 : 12.0) : (isCompact ? 10.0 : 16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: isCompact ? 32.0 : 40.0,
                  height: isCompact ? 32.0 : 40.0,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(data.icon, color: data.color, size: iconSize),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OverflowHelper.handleLongText(
                    text: data.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Spacer(),
            OverflowHelper.handleLongText(
              text: data.value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (data.isPositive ? Colors.green : Colors.red)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.isPositive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: isSmallScreen ? 8.0 : 10.0,
                        color: data.isPositive ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 2),
                      OverflowHelper.handleLongText(
                        text: data.trend,
                        style: TextStyle(
                          fontSize: trendFontSize,
                          fontWeight: FontWeight.bold,
                          color: data.isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
