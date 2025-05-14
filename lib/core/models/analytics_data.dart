import 'package:flutter/material.dart';

class AnalyticsData {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final bool isPositive;

  AnalyticsData({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    required this.isPositive,
  });
}

class EmotionTrend {
  final String emotion;
  final List<double> values;
  final Color color;

  EmotionTrend({
    required this.emotion,
    required this.values,
    required this.color,
  });
}

class CustomerSegment {
  final String name;
  final double percentage;
  final Color color;

  CustomerSegment({
    required this.name,
    required this.percentage,
    required this.color,
  });
}

class EmotionInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String timestamp;
  final Function()? onAction;

  EmotionInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.timestamp,
    this.onAction,
  });
}
