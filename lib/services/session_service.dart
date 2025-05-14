import '../models/session.dart';
import 'package:flutter/material.dart';

class SessionService {
  // In a real app, this would be connected to a backend or local database

  // Get all sessions
  Future<List<Session>> getSessions() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    return [
      Session(
        id: '1',
        customer: 'John Smith',
        time: '10:05 AM',
        duration: '12m 34s',
        emotion: 'Angry',
        agentAction: 'Escalated to supervisor',
        emotionColor: Colors.red,
      ),
      Session(
        id: '2',
        customer: 'Sarah Johnson',
        time: '11:32 AM',
        duration: '8m 12s',
        emotion: 'Happy',
        agentAction: 'Resolved issue',
        emotionColor: Colors.green,
      ),
      Session(
        id: '3',
        customer: 'Michael Brown',
        time: '01:45 PM',
        duration: '15m 47s',
        emotion: 'Confused',
        agentAction: 'Provided detailed guide',
        emotionColor: Colors.blue,
      ),
      Session(
        id: '4',
        customer: 'Emily Davis',
        time: '03:20 PM',
        duration: '5m 39s',
        emotion: 'Frustrated',
        agentAction: 'Offered discount',
        emotionColor: Colors.orange,
      ),
    ];
  }

  // Get session by ID
  Future<Session?> getSessionById(String id) async {
    final sessions = await getSessions();
    try {
      return sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter sessions by emotion
  Future<List<Session>> getSessionsByEmotion(String emotion) async {
    final sessions = await getSessions();
    return sessions.where((session) => session.emotion == emotion).toList();
  }

  // Save a new session (in a real app, this would persist data)
  Future<bool> saveSession(Session session) async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
