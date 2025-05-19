import 'package:flutter/material.dart';
import '../../domain/entities/emotion.dart';

/// Data model for emotions
class EmotionModel extends Emotion {
  const EmotionModel({
    required String name,
    required double intensity,
    required Color color,
    required IconData icon,
  }) : super(name: name, intensity: intensity, color: color, icon: icon);

  /// Create an EmotionModel from JSON
  factory EmotionModel.fromJson(Map<String, dynamic> json) {
    return EmotionModel(
      name: json['name'] as String,
      intensity: (json['intensity'] as num).toDouble(),
      color: Color(json['color'] as int),
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  /// Convert EmotionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'intensity': intensity,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }

  /// Create an EmotionModel from an Emotion entity
  factory EmotionModel.fromEntity(Emotion emotion) {
    return EmotionModel(
      name: emotion.name,
      intensity: emotion.intensity,
      color: emotion.color,
      icon: emotion.icon,
    );
  }

  /// Convert EmotionModel to an Emotion entity
  Emotion toEntity() {
    return Emotion(name: name, intensity: intensity, color: color, icon: icon);
  }
}
