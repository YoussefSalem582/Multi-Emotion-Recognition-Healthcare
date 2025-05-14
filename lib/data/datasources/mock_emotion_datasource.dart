import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/emotion_model.dart';

/// Mock data source for emotions
class MockEmotionDataSource {
  final Random _random = Random();

  /// Detect emotions from audio input (mock implementation)
  Future<List<EmotionModel>> detectEmotionsFromAudio(
    String audioFilePath,
  ) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock emotions
    return _generateMockEmotions();
  }

  /// Detect emotions from video input (mock implementation)
  Future<List<EmotionModel>> detectEmotionsFromVideo(
    String videoFilePath,
  ) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 3));

    // Return mock emotions
    return _generateMockEmotions();
  }

  /// Detect emotions in real-time from microphone (mock implementation)
  Stream<EmotionModel> detectEmotionsLive() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return _generateRandomEmotion();
    });
  }

  /// Get emotion history for a session (mock implementation)
  Future<List<EmotionModel>> getEmotionHistory(String sessionId) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock emotions
    return _generateMockEmotions();
  }

  /// Save an emotion detection (mock implementation)
  Future<void> saveEmotionDetection(
    String sessionId,
    EmotionModel emotion,
    DateTime timestamp,
  ) async {
    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real implementation, this would save to a database
    print('Saved emotion ${emotion.name} for session $sessionId at $timestamp');
  }

  /// Generate a list of mock emotions
  List<EmotionModel> _generateMockEmotions() {
    return [
      EmotionModel(
        name: 'Happy',
        intensity: 0.7,
        color: Colors.green,
        icon: Icons.sentiment_very_satisfied,
      ),
      EmotionModel(
        name: 'Neutral',
        intensity: 0.2,
        color: Colors.grey,
        icon: Icons.sentiment_neutral,
      ),
      EmotionModel(
        name: 'Frustrated',
        intensity: 0.1,
        color: Colors.orange,
        icon: Icons.sentiment_dissatisfied,
      ),
    ];
  }

  /// Generate a random emotion
  EmotionModel _generateRandomEmotion() {
    final emotions = [
      EmotionModel(
        name: 'Happy',
        intensity: _random.nextDouble() * 0.5 + 0.5, // 0.5 to 1.0
        color: Colors.green,
        icon: Icons.sentiment_very_satisfied,
      ),
      EmotionModel(
        name: 'Neutral',
        intensity: _random.nextDouble() * 0.3 + 0.3, // 0.3 to 0.6
        color: Colors.grey,
        icon: Icons.sentiment_neutral,
      ),
      EmotionModel(
        name: 'Sad',
        intensity: _random.nextDouble() * 0.4 + 0.3, // 0.3 to 0.7
        color: Colors.blue,
        icon: Icons.sentiment_dissatisfied,
      ),
      EmotionModel(
        name: 'Angry',
        intensity: _random.nextDouble() * 0.3 + 0.6, // 0.6 to 0.9
        color: Colors.red,
        icon: Icons.sentiment_very_dissatisfied,
      ),
      EmotionModel(
        name: 'Frustrated',
        intensity: _random.nextDouble() * 0.4 + 0.4, // 0.4 to 0.8
        color: Colors.orange,
        icon: Icons.sentiment_dissatisfied,
      ),
      EmotionModel(
        name: 'Confused',
        intensity: _random.nextDouble() * 0.3 + 0.3, // 0.3 to 0.6
        color: Colors.purple,
        icon: Icons.psychology,
      ),
    ];

    return emotions[_random.nextInt(emotions.length)];
  }
}
