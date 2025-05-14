import '../entities/emotion.dart';

/// Repository interface for emotion data
abstract class EmotionRepository {
  /// Detect emotions from audio input
  Future<List<Emotion>> detectEmotionsFromAudio(String audioFilePath);

  /// Detect emotions from video input
  Future<List<Emotion>> detectEmotionsFromVideo(String videoFilePath);

  /// Detect emotions in real-time from microphone
  Stream<Emotion> detectEmotionsLive();

  /// Get emotion history for a session
  Future<List<Emotion>> getEmotionHistory(String sessionId);

  /// Save an emotion detection
  Future<void> saveEmotionDetection(
    String sessionId,
    Emotion emotion,
    DateTime timestamp,
  );
}
