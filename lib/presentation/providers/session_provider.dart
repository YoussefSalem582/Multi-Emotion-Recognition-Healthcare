import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_usecase.dart';

/// Provider for session data
class SessionProvider extends ChangeNotifier {
  final GetSessionsUseCase _getSessionsUseCase;

  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _error;

  SessionProvider(this._getSessionsUseCase);

  /// Get all sessions
  List<Session> get sessions => _sessions;

  /// Check if data is loading
  bool get isLoading => _isLoading;

  /// Get error message
  String? get error => _error;

  /// Load all sessions
  Future<void> loadSessions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessions = await _getSessionsUseCase.getAllSessions();
    } catch (e) {
      _error = 'Failed to load sessions: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a session by ID
  Future<Session?> getSessionById(String id) async {
    try {
      return await _getSessionsUseCase.getSessionById(id);
    } catch (e) {
      _error = 'Failed to load session: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  /// Get sessions by customer name
  Future<List<Session>> getSessionsByCustomer(String customerName) async {
    try {
      return await _getSessionsUseCase.getSessionsByCustomer(customerName);
    } catch (e) {
      _error = 'Failed to load sessions: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  /// Get sessions from a specific date range
  Future<List<Session>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _getSessionsUseCase.getSessionsByDateRange(start, end);
    } catch (e) {
      _error = 'Failed to load sessions: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
