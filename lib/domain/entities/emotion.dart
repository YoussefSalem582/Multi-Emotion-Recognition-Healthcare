import 'package:flutter/material.dart';

/// Represents an emotion detected by the application
class Emotion {
  final String name;
  final double intensity;
  final Color color;
  final IconData icon;

  const Emotion({
    required this.name,
    required this.intensity,
    required this.color,
    required this.icon,
  });

  /// Factory method to create a predefined emotion
  factory Emotion.predefined(String name, double intensity) {
    switch (name.toLowerCase()) {
      case 'happy':
        return Emotion(
          name: 'Happy',
          intensity: intensity,
          color: Colors.green,
          icon: Icons.sentiment_very_satisfied,
        );
      case 'neutral':
        return Emotion(
          name: 'Neutral',
          intensity: intensity,
          color: Colors.grey,
          icon: Icons.sentiment_neutral,
        );
      case 'sad':
        return Emotion(
          name: 'Sad',
          intensity: intensity,
          color: Colors.blue,
          icon: Icons.sentiment_dissatisfied,
        );
      case 'angry':
        return Emotion(
          name: 'Angry',
          intensity: intensity,
          color: Colors.red,
          icon: Icons.sentiment_very_dissatisfied,
        );
      case 'frustrated':
        return Emotion(
          name: 'Frustrated',
          intensity: intensity,
          color: Colors.orange,
          icon: Icons.sentiment_dissatisfied,
        );
      case 'confused':
        return Emotion(
          name: 'Confused',
          intensity: intensity,
          color: Colors.purple,
          icon: Icons.psychology,
        );
      default:
        return Emotion(
          name: name,
          intensity: intensity,
          color: Colors.grey,
          icon: Icons.emoji_emotions,
        );
    }
  }

  /// Create a copy of this emotion with different properties
  Emotion copyWith({
    String? name,
    double? intensity,
    Color? color,
    IconData? icon,
  }) {
    return Emotion(
      name: name ?? this.name,
      intensity: intensity ?? this.intensity,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}
