import 'package:flutter/material.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/services/sessions/session_service.dart';

/// ViewModel for Session management
/// Handles business logic and state management between View and Model
class SessionViewModel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize and fetch sessions
  Future<void> initialize() async {
    await fetchSessions();
  }

  /// Fetch all sessions from service
  Future<void> fetchSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sessions = await _sessionService.getSessions();
    } catch (e) {
      _errorMessage = 'Failed to fetch sessions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new session
  Future<void> createSession(String title) async {
    if (title.isEmpty) {
      _errorMessage = 'Session title cannot be empty';
      notifyListeners();
      return;
    }

    try {
      final newSession = await _sessionService.createSession(title);
      _sessions.add(newSession);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to create session: $e';
    }
    notifyListeners();
  }

  /// Update a session
  Future<void> updateSession(String id, String title) async {
    try {
      final updated = await _sessionService.updateSession(id, title);
      final index = _sessions.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sessions[index] = updated;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update session: $e';
    }
    notifyListeners();
  }

  /// Delete a session
  Future<void> deleteSession(String id) async {
    try {
      await _sessionService.deleteSession(id);
      _sessions.removeWhere((s) => s.id == id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete session: $e';
    }
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
