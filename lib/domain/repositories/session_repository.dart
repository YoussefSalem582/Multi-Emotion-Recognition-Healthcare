import '../entities/session.dart';

/// Repository interface for session data
abstract class SessionRepository {
  /// Get all sessions
  Future<List<Session>> getAllSessions();

  /// Get a session by ID
  Future<Session?> getSessionById(String id);

  /// Save a session
  Future<void> saveSession(Session session);

  /// Delete a session by ID
  Future<void> deleteSession(String id);

  /// Get sessions filtered by customer name
  Future<List<Session>> getSessionsByCustomer(String customerName);

  /// Get sessions from a specific date range
  Future<List<Session>> getSessionsByDateRange(DateTime start, DateTime end);
}
