import 'dart:math';
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/emotion_model.dart';
import '../../domain/entities/session.dart';

/// Mock data source for sessions
class MockSessionDataSource {
  final List<SessionModel> _sessions = [];
  final Random _random = Random();

  MockSessionDataSource() {
    // Initialize with some mock sessions
    _initializeMockSessions();
  }

  /// Get all sessions
  Future<List<SessionModel>> getAllSessions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _sessions;
  }

  /// Get a session by ID
  Future<SessionModel?> getSessionById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Save a session
  Future<void> saveSession(SessionModel session) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check if session already exists
    final index = _sessions.indexWhere((s) => s.id == session.id);

    if (index >= 0) {
      // Update existing session
      _sessions[index] = session;
    } else {
      // Add new session
      _sessions.add(session);
    }
  }

  /// Delete a session by ID
  Future<void> deleteSession(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    _sessions.removeWhere((session) => session.id == id);
  }

  /// Get sessions filtered by customer name
  Future<List<SessionModel>> getSessionsByCustomer(String customerName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return _sessions
        .where(
          (session) => session.customerName.toLowerCase().contains(
            customerName.toLowerCase(),
          ),
        )
        .toList();
  }

  /// Get sessions from a specific date range
  Future<List<SessionModel>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return _sessions
        .where(
          (session) =>
              session.timestamp.isAfter(start) &&
              session.timestamp.isBefore(end),
        )
        .toList();
  }

  /// Initialize mock sessions
  void _initializeMockSessions() {
    final customers = [
      'John Smith',
      'Sarah Johnson',
      'Michael Brown',
      'Emily Davis',
      'Robert Wilson',
    ];

    final agentActions = [
      'Resolved issue',
      'Escalated to supervisor',
      'Provided detailed guide',
      'Offered discount',
      'Scheduled follow-up call',
      null,
    ];

    final now = DateTime.now();

    // Create 10 mock sessions
    for (int i = 0; i < 10; i++) {
      final customerName = customers[_random.nextInt(customers.length)];
      final timestamp = now.subtract(
        Duration(
          days: _random.nextInt(30),
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        ),
      );
      final duration = Duration(minutes: _random.nextInt(20) + 3);

      // Create primary emotion
      final primaryEmotion = _createRandomEmotion();

      // Create emotion timeline
      final emotionTimeline = _createRandomEmotionTimeline(duration);

      // Create session
      final session = SessionModel(
        id: 'session_${i + 1}',
        customerName: customerName,
        timestamp: timestamp,
        duration: duration,
        primaryEmotion: primaryEmotion,
        emotionTimeline: emotionTimeline,
        agentAction: agentActions[_random.nextInt(agentActions.length)],
        notes: _random.nextBool() ? 'Sample notes for session ${i + 1}' : null,
      );

      _sessions.add(session);
    }
  }

  /// Create a random emotion
  EmotionModel _createRandomEmotion() {
    final emotions = [
      'Happy',
      'Neutral',
      'Sad',
      'Angry',
      'Frustrated',
      'Confused',
    ];

    final colors = [
      Colors.green,
      Colors.grey,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    final icons = [
      Icons.sentiment_very_satisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.psychology,
    ];

    final index = _random.nextInt(emotions.length);

    return EmotionModel(
      name: emotions[index],
      intensity: _random.nextDouble() * 0.6 + 0.4, // 0.4 to 1.0
      color: colors[index],
      icon: icons[index],
    );
  }

  /// Create a random emotion timeline
  List<EmotionTimepointModel> _createRandomEmotionTimeline(
    Duration sessionDuration,
  ) {
    final timeline = <EmotionTimepointModel>[];

    // Create 5-15 timepoints
    final numTimepoints = _random.nextInt(10) + 5;

    for (int i = 0; i < numTimepoints; i++) {
      final timeOffset = Duration(
        seconds: _random.nextInt(sessionDuration.inSeconds),
      );

      timeline.add(
        EmotionTimepointModel(
          emotion: _createRandomEmotion(),
          timeOffset: timeOffset,
        ),
      );
    }

    // Sort by time offset
    timeline.sort((a, b) => a.timeOffset.compareTo(b.timeOffset));

    return timeline;
  }
}
