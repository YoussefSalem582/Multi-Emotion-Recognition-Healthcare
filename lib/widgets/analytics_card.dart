import 'package:flutter/material.dart';
import '../models/analytics_data.dart';

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
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(data.icon, color: data.color, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data.title,
                      style: TextStyle(
                        fontSize: isCompact ? 13 : 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 8 : 12),
              Text(
                data.value,
                style: TextStyle(
                  fontSize: isCompact ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (data.isPositive ? Colors.green : Colors.red)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          data.isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12,
                          color: data.isPositive ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text(
                          data.trend,
                          style: TextStyle(
                            fontSize: 12,
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
      ),
    );
  }
}

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

class InsightCard extends StatelessWidget {
  final EmotionInsight insight;

  const InsightCard({Key? key, required this.insight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: insight.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(insight.icon, color: insight.color, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        insight.timestamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              insight.description,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            if (insight.onAction != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: insight.onAction,
                  child: Text('Take Action'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
