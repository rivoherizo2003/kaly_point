import 'package:kaly_point/dto/add_session_dto.dart';
import 'package:kaly_point/dto/edit_session_dto.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/services/abstract_service.dart';

class SessionService extends AbstractService {
  /// Fetch all sessions
  Future<List<Session>> getSessions({
    required int page,
    required int limit,
  }) async {
    final int offset = (page - 1) * limit;
    final db = await databaseService.database;
    final results = await db
        .rawQuery(
          '''
              SELECT
                s.id,
                s.title,
                s.description,
                s.created_at,
                (SELECT COUNT(*) FROM session_person sp WHERE sp.session_id = s.id ) AS nbr_person_in_session
              FROM sessions s
              ORDER BY created_at DESC LIMIT ?1 OFFSET ?2
            ''',
          [limit, offset],
        )
        .onError((error, stackTrace) {
          throw Exception('Failed to fetch sessions: $error');
        });

    return results.map((session) => Session.fromMap(session)).toList();
  }

  Future<int> insertSession(AddSessionDto session) async {
    try {
      final db = await databaseService.database;
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

  Future<EditSessionDto> updateSession(EditSessionDto session) async {
    try {
      final db = await databaseService.database;
      await db.update(
        "sessions",
        {'title': session.title, 'description': session.description},
        where: 'id = ?',
        whereArgs: [session.id],
      );

      return session;
    } catch (error) {
      throw Exception("Failed to update session: $error");
    }
  }

  Future<void> deleteSession(int id) async {
    try {
      final db = await databaseService.database;
      await db.delete("sessions", where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      throw Exception("Failed to delete session: $error");
    }
  }

  Future<Session> findOneById(int sessionId) async {
    try {
      final db = await databaseService.database;
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
