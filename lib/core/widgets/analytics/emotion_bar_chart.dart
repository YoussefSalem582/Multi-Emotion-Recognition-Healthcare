import 'package:flutter/material.dart';

/// A bar chart widget for displaying emotion data
class EmotionBarChart extends StatelessWidget {
  final Map<String, double> emotionData;

  const EmotionBarChart({Key? key, required this.emotionData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort emotions by value in descending order
    final sortedEmotions =
        emotionData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sortedEmotions.map((entry) {
          final emotion = entry.key;
          final value = entry.value;
          final color = _getEmotionColor(emotion);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      emotion,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text('${(value * 100).toInt()}%'),
                  ],
                ),
                SizedBox(height: 6),
                LinearProgressIndicator(
                  value: value,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }
}
