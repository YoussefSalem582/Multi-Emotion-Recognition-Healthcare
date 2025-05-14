import '../entities/emotion.dart';
import '../repositories/emotion_repository.dart';

/// Use case for detecting emotions
class DetectEmotionsUseCase {
  final EmotionRepository repository;

  DetectEmotionsUseCase(this.repository);

  /// Detect emotions from audio input
  Future<List<Emotion>> detectFromAudio(String audioFilePath) async {
    return await repository.detectEmotionsFromAudio(audioFilePath);
  }

  /// Detect emotions from video input
  Future<List<Emotion>> detectFromVideo(String videoFilePath) async {
    return await repository.detectEmotionsFromVideo(videoFilePath);
  }

  /// Detect emotions in real-time from microphone
  Stream<Emotion> detectLive() {
    return repository.detectEmotionsLive();
  }

  /// Save an emotion detection
  Future<void> saveEmotionDetection(
    String sessionId,
    Emotion emotion,
    DateTime timestamp,
  ) async {
    await repository.saveEmotionDetection(sessionId, emotion, timestamp);
  }
}
