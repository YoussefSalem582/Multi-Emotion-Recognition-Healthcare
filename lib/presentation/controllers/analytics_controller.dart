import 'package:flutter/material.dart';
import '../../domain/entities/emotion.dart';
import '../providers/emotion_provider.dart';

/// Controller for handling analytics-related functionality
class AnalyticsController {
  final EmotionProvider _emotionProvider;

  AnalyticsController(this._emotionProvider);

  /// Get all detected emotions
  List<Emotion> get detectedEmotions => _emotionProvider.detectedEmotions;

  /// Get current emotion
  Emotion? get currentEmotion => _emotionProvider.currentEmotion;

  /// Check if detection is in progress
  bool get isDetecting => _emotionProvider.isDetecting;

  /// Get error message
  String? get error => _emotionProvider.error;

  /// Calculate average emotion intensity
  double getAverageEmotionIntensity() {
    if (detectedEmotions.isEmpty) return 0.0;

    final totalIntensity = detectedEmotions.fold<double>(
      0.0,
      (sum, emotion) => sum + emotion.intensity,
    );

    return totalIntensity / detectedEmotions.length;
  }

  /// Get most frequent emotion
  Emotion? getMostFrequentEmotion() {
    if (detectedEmotions.isEmpty) return null;

    final emotionCounts = <String, int>{};
    for (final emotion in detectedEmotions) {
      emotionCounts[emotion.name] = (emotionCounts[emotion.name] ?? 0) + 1;
    }

    String? mostFrequentEmotionName;
    int maxCount = 0;

    emotionCounts.forEach((name, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequentEmotionName = name;
      }
    });

    return detectedEmotions.firstWhere(
      (emotion) => emotion.name == mostFrequentEmotionName,
    );
  }

  /// Get emotion distribution
  Map<String, double> getEmotionDistribution() {
    if (detectedEmotions.isEmpty) return {};

    final totalEmotions = detectedEmotions.length;
    final distribution = <String, double>{};

    for (final emotion in detectedEmotions) {
      distribution[emotion.name] = (distribution[emotion.name] ?? 0) + 1;
    }

    return distribution.map(
      (name, count) => MapEntry(name, count / totalEmotions),
    );
  }

  /// Get emotion timeline
  List<MapEntry<DateTime, Emotion>> getEmotionTimeline() {
    // This would need to be implemented based on how timestamps are stored
    // with the emotions. For now, returning an empty list.
    return [];
  }

  /// Clear error message
  void clearError() {
    _emotionProvider.clearError();
  }
}
