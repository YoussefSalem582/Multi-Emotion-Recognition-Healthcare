import '../../domain/entities/session.dart';
import '../../domain/entities/emotion.dart';
import 'emotion_model.dart';

/// Data model for sessions
class SessionModel extends Session {
  const SessionModel({
    required String id,
    required String customerName,
    required DateTime timestamp,
    required Duration duration,
    required Emotion primaryEmotion,
    required List<EmotionTimepoint> emotionTimeline,
    String? agentAction,
    String? notes,
  }) : super(
         id: id,
         customerName: customerName,
         timestamp: timestamp,
         duration: duration,
         primaryEmotion: primaryEmotion,
         emotionTimeline: emotionTimeline,
         agentAction: agentAction,
         notes: notes,
       );

  /// Create a SessionModel from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final emotionTimeline =
        (json['emotionTimeline'] as List)
            .map(
              (e) => EmotionTimepointModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();

    return SessionModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: Duration(seconds: json['durationSeconds'] as int),
      primaryEmotion: EmotionModel.fromJson(
        json['primaryEmotion'] as Map<String, dynamic>,
      ),
      emotionTimeline: emotionTimeline,
      agentAction: json['agentAction'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Convert SessionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'primaryEmotion': (primaryEmotion as EmotionModel).toJson(),
      'emotionTimeline':
          emotionTimeline
              .map((e) => (e as EmotionTimepointModel).toJson())
              .toList(),
      'agentAction': agentAction,
      'notes': notes,
    };
  }

  /// Create a SessionModel from a Session entity
  factory SessionModel.fromEntity(Session session) {
    return SessionModel(
      id: session.id,
      customerName: session.customerName,
      timestamp: session.timestamp,
      duration: session.duration,
      primaryEmotion: EmotionModel.fromEntity(session.primaryEmotion),
      emotionTimeline:
          session.emotionTimeline
              .map((e) => EmotionTimepointModel.fromEntity(e))
              .toList(),
      agentAction: session.agentAction,
      notes: session.notes,
    );
  }

  /// Convert SessionModel to a Session entity
  Session toEntity() {
    return Session(
      id: id,
      customerName: customerName,
      timestamp: timestamp,
      duration: duration,
      primaryEmotion: (primaryEmotion as EmotionModel).toEntity(),
      emotionTimeline:
          emotionTimeline
              .map((e) => (e as EmotionTimepointModel).toEntity())
              .toList(),
      agentAction: agentAction,
      notes: notes,
    );
  }
}

/// Data model for emotion timepoints
class EmotionTimepointModel extends EmotionTimepoint {
  const EmotionTimepointModel({
    required Emotion emotion,
    required Duration timeOffset,
  }) : super(emotion: emotion, timeOffset: timeOffset);

  /// Create an EmotionTimepointModel from JSON
  factory EmotionTimepointModel.fromJson(Map<String, dynamic> json) {
    return EmotionTimepointModel(
      emotion: EmotionModel.fromJson(json['emotion'] as Map<String, dynamic>),
      timeOffset: Duration(seconds: json['timeOffsetSeconds'] as int),
    );
  }

  /// Convert EmotionTimepointModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'emotion': (emotion as EmotionModel).toJson(),
      'timeOffsetSeconds': timeOffset.inSeconds,
    };
  }

  /// Create an EmotionTimepointModel from an EmotionTimepoint entity
  factory EmotionTimepointModel.fromEntity(EmotionTimepoint timepoint) {
    return EmotionTimepointModel(
      emotion: EmotionModel.fromEntity(timepoint.emotion),
      timeOffset: timepoint.timeOffset,
    );
  }

  /// Convert EmotionTimepointModel to an EmotionTimepoint entity
  EmotionTimepoint toEntity() {
    return EmotionTimepoint(
      emotion: (emotion as EmotionModel).toEntity(),
      timeOffset: timeOffset,
    );
  }
}
