import 'package:flutter/material.dart';

/// A widget for displaying an emotion explanation row in the dashboard
class EmotionExplanationRow extends StatelessWidget {
  final String emotion;
  final String description;
  final Color? emotionColor;
  final IconData? emotionIcon;

  const EmotionExplanationRow({
    Key? key,
    required this.emotion,
    required this.description,
    this.emotionColor,
    this.emotionIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = emotionColor ?? _getEmotionColor(emotion);
    final IconData icon = emotionIcon ?? _getEmotionIcon(emotion);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
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

  IconData _getEmotionIcon(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Neutral':
        return Icons.sentiment_neutral;
      case 'Confused':
        return Icons.psychology;
      case 'Frustrated':
        return Icons.sentiment_dissatisfied;
      case 'Angry':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.emoji_emotions;
    }
  }
}
