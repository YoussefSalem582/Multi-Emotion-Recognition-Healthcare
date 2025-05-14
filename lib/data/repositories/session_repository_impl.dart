import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/mock_session_datasource.dart';
import '../models/session_model.dart';

/// Implementation of the SessionRepository interface
class SessionRepositoryImpl implements SessionRepository {
  final MockSessionDataSource dataSource;

  SessionRepositoryImpl(this.dataSource);

  @override
  Future<List<Session>> getAllSessions() async {
    final sessions = await dataSource.getAllSessions();
    return sessions;
  }

  @override
  Future<Session?> getSessionById(String id) async {
    final session = await dataSource.getSessionById(id);
    return session;
  }

  @override
  Future<void> saveSession(Session session) async {
    await dataSource.saveSession(
      session is SessionModel ? session : SessionModel.fromEntity(session),
    );
  }

  @override
  Future<void> deleteSession(String id) async {
    await dataSource.deleteSession(id);
  }

  @override
  Future<List<Session>> getSessionsByCustomer(String customerName) async {
    final sessions = await dataSource.getSessionsByCustomer(customerName);
    return sessions;
  }

  @override
  Future<List<Session>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await dataSource.getSessionsByDateRange(start, end);
    return sessions;
  }
}
