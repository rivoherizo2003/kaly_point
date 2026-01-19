import 'package:flutter/rendering.dart';
import 'package:kaly_point/models/add_session.dart';
import 'package:kaly_point/models/edit_session.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/services/database_service.dart';

/// Service responsible for session-related operations
/// Handles API calls, database operations, etc.
class SessionService {
  final _databaseService = DatabaseService();

  /// Fetch all sessions
  Future<List<Session>> getSessions({required int page, required int limit}) async {
    final db = await _databaseService.database;

    final int offset = (page - 1) * limit;

    final results = await db
        .query("sessions",limit: limit, offset: offset, orderBy: "created_at DESC")
        .onError((error, stackTrace) {
          throw Exception('Failed to fetch sessions: $error');
        });

    return results
        .map(
          (session) => Session.fromMap(session),
        )
        .toList();
  }

  Future<int> insertSession(AddSession session) async {
    final db = await _databaseService.database;
    try {
      final id = await db.insert("sessions", {
        'title': session.title,
        'description': session.description,
        'created_at': session.createdAt.toIso8601String(),
      });

      return id;
    } catch (error) {
      throw Exception("Failed to insert session: $error");
    }
  }

  Future<EditSession> updateSession(EditSession session) async {
    final db = await _databaseService.database;
    try {
      await db.update(
        "sessions",
        {'title': session.title, 'description': session.description},
        where: 'id = ?',
        whereArgs: [session.id]
      );

      return session;
    } catch (error) {
      throw Exception("Failed to update session: $error");
    }
  }

  Future<void> deleteSession(int id) async {
    final db = await _databaseService.database;

    try {
      db.delete("sessions", where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      throw Exception("Failed to delete session: $error");
    }
  }

  Future<Session> findOneById(int sessionId) async {
    final db = await _databaseService.database;

    try {
      final List<Map<String, dynamic>> session = await db.query(
        "sessions",
        where: 'id = ?',
        whereArgs: [sessionId],
        limit: 1,
      );

      return Session.fromMap(session.first);
    } catch (error) {
      throw Exception("Failed to retrieve session: $error");
    }
  }
}
