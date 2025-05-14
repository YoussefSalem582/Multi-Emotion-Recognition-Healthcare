import '../entities/session.dart';
import '../repositories/session_repository.dart';

/// Use case for retrieving sessions
class GetSessionsUseCase {
  final SessionRepository repository;

  GetSessionsUseCase(this.repository);

  /// Get all sessions
  Future<List<Session>> getAllSessions() async {
    return await repository.getAllSessions();
  }

  /// Get a session by ID
  Future<Session?> getSessionById(String id) async {
    return await repository.getSessionById(id);
  }

  /// Get sessions by customer name
  Future<List<Session>> getSessionsByCustomer(String customerName) async {
    return await repository.getSessionsByCustomer(customerName);
  }

  /// Get sessions from a specific date range
  Future<List<Session>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getSessionsByDateRange(start, end);
  }
}
