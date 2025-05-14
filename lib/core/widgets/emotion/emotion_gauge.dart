import 'package:flutter/material.dart';

/// A gauge widget for visualizing emotion intensity
class EmotionGauge extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const EmotionGauge({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 100 * value,
                width: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
        Text(
          '${(value * 100).round()}%',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
