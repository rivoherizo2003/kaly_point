import 'package:kaly_point/models/session.dart';

/// Service responsible for session-related operations
/// Handles API calls, database operations, etc.
class SessionService {
  // Simulated list of sessions (replace with actual API/database calls)
  final List<Session> _sessions = [];

  /// Fetch all sessions
  Future<List<Session>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Session>.generate(
      20,
      (i) => Session(
        id: i.toString(),
        title: 'Session $i',
        description: "détails de la session",
        createdAt: DateTime.now().subtract(Duration(days: i)),
      ),
    );
  }

  /// Create a new session
  Future<Session> createSession(String title) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final newSession = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
    );
    
    _sessions.add(newSession);
    return newSession;
  }

  /// Update a session
  Future<Session> updateSession(String id, String title) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final updated = Session(
        id: id,
        title: title,
        createdAt: _sessions[index].createdAt,
        updatedAt: DateTime.now(),
      );
      _sessions[index] = updated;
      return updated;
    }
    throw Exception('Session not found');
  }

  /// Delete a session
  Future<void> deleteSession(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessions.removeWhere((s) => s.id == id);
  }
}
