import '../../domain/entities/emotion.dart';
import '../../domain/repositories/emotion_repository.dart';
import '../datasources/mock_emotion_datasource.dart';
import '../models/emotion_model.dart';

/// Implementation of the EmotionRepository interface
class EmotionRepositoryImpl implements EmotionRepository {
  final MockEmotionDataSource dataSource;

  EmotionRepositoryImpl(this.dataSource);

  @override
  Future<List<Emotion>> detectEmotionsFromAudio(String audioFilePath) async {
    final emotions = await dataSource.detectEmotionsFromAudio(audioFilePath);
    return emotions;
  }

  @override
  Future<List<Emotion>> detectEmotionsFromVideo(String videoFilePath) async {
    final emotions = await dataSource.detectEmotionsFromVideo(videoFilePath);
    return emotions;
  }

  @override
  Stream<Emotion> detectEmotionsLive() {
    return dataSource.detectEmotionsLive();
  }

  @override
  Future<List<Emotion>> getEmotionHistory(String sessionId) async {
    final emotions = await dataSource.getEmotionHistory(sessionId);
    return emotions;
  }

  @override
  Future<void> saveEmotionDetection(
    String sessionId,
    Emotion emotion,
    DateTime timestamp,
  ) async {
    await dataSource.saveEmotionDetection(
      sessionId,
      emotion is EmotionModel ? emotion : EmotionModel.fromEntity(emotion),
      timestamp,
    );
  }
}
