import 'package:flutter/material.dart';

class EmotionCard extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const EmotionCard({
    Key? key,
    required this.label,
    required this.score,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.emoji_emotions, color: color),
        ),
        title: Text(label),
        subtitle: LinearProgressIndicator(
          value: score,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        trailing: Text(
          '${(score * 100).round()}%',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
