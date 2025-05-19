import 'package:flutter/material.dart';
import 'emotion.dart';

/// Represents a customer service session with emotion data
class Session {
  final String id;
  final String customerName;
  final DateTime timestamp;
  final Duration duration;
  final Emotion primaryEmotion;
  final List<EmotionTimepoint> emotionTimeline;
  final String? agentAction;
  final String? notes;

  const Session({
    required this.id,
    required this.customerName,
    required this.timestamp,
    required this.duration,
    required this.primaryEmotion,
    required this.emotionTimeline,
    this.agentAction,
    this.notes,
  });

  /// Create a copy of this session with different properties
  Session copyWith({
    String? id,
    String? customerName,
    DateTime? timestamp,
    Duration? duration,
    Emotion? primaryEmotion,
    List<EmotionTimepoint>? emotionTimeline,
    String? agentAction,
    String? notes,
  }) {
    return Session(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      primaryEmotion: primaryEmotion ?? this.primaryEmotion,
      emotionTimeline: emotionTimeline ?? this.emotionTimeline,
      agentAction: agentAction ?? this.agentAction,
      notes: notes ?? this.notes,
    );
  }

  /// Format the session time as a string
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}';
  }

  /// Format the duration as a string
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}

/// Represents an emotion at a specific point in time
class EmotionTimepoint {
  final Emotion emotion;
  final Duration timeOffset;

  const EmotionTimepoint({required this.emotion, required this.timeOffset});

  /// Format the time offset as a string
  String get formattedTimeOffset {
    final minutes = timeOffset.inMinutes;
    final seconds = timeOffset.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
