import 'package:flutter/material.dart';
import 'package:kaly_point/models/add_session.dart';
import 'package:kaly_point/models/edit_session.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/services/sessions/session_service.dart';

/// ViewModel for Session management
/// Handles business logic and state management between View and Model
class SessionViewModel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  List<Session> _sessions = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _currentPage = 1;
  final int _pageSize = 5;
  String? _errorMessage;

  // Getters
  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;

  /// Initialize and fetch sessions
  Future<void> initialize({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _sessions.clear();
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
    }

    await fetchSessions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    notifyListeners();
    await fetchSessions();

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Fetch all sessions from service
  Future<void> fetchSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final sessions = await _sessionService.getSessions(
        page: _currentPage,
        limit: _pageSize,
      );
      if (sessions.isNotEmpty) {
        _sessions.addAll(sessions);
        _hasMore = true;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch sessions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new session
  Future<void> createSession(AddSession newSession) async {
    if (newSession.title.isEmpty) {
      _errorMessage = 'Session title cannot be empty';
      notifyListeners();
      return;
    }

    try {
      int idNewSession = await _sessionService.insertSession(newSession);
      _sessions.insert(0, Session(id: idNewSession, title: newSession.title, createdAt: newSession.createdAt, description: newSession.description));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to create session: $e';
    }
    notifyListeners();
  }

  /// Update a session
  Future<void> saveSession(EditSession session) async {
    try {
      final sessionUpdated = await _sessionService.updateSession(session);
      final index = _sessions.indexWhere((s) => s.id == session.id);
      if (index != -1) {
        final session = _sessions[index];
        _sessions[index] = Session(
          id: sessionUpdated.id,
          title: sessionUpdated.title,
          description: sessionUpdated.description,
          createdAt: session.createdAt,
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update session: $e';
    }
    notifyListeners();
  }

  /// Delete a session
  Future<void> deleteSession(int id) async {
    try {
      await _sessionService.deleteSession(id);
        _sessions.remove(_sessions.where((s) => s.id == id).first);

      if(_sessions.length < _pageSize){
        _sessions.clear();
        await fetchSessions();
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete session: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<EditSession?> getSessionById(int sessionId) async {
    try {
      return await _sessionService.findOneById(sessionId);
    } catch (error) {
      _errorMessage = 'Failed to retrieve session: $error';
    }
    return null;
  }
}
