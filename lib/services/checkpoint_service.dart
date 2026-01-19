import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/models/edit_check_point.dart';
import 'package:kaly_point/models/new_check_point.dart';
import 'package:kaly_point/services/database_service.dart';

class CheckpointService {
  final _databaseService = DatabaseService();

  Future<dynamic> getCheckPoints({
    required int page,
    required int limit,
    required int sessionId
  }) async {
    final db = await _databaseService.database;

    final int offset = (page - 1) * limit;

    final results = await db
        .query(
          "check_points",
          limit: limit,
          offset: offset,
          orderBy: "created_at DESC",
          where: 'session_id = ?',
          whereArgs: [sessionId]
        )
        .onError((error, stackTrace) {
          throw Exception('Failed to fetch check points: $error');
        });

    return results.map((checkpoint) => CheckPoint.fromMap(checkpoint));
  }

  Future<int> insertNewCheckPoint(NewCheckPoint newCheckPoint) async {
    final db = await _databaseService.database;
    try {
      final id = await db.insert("check_points", {
        'title': newCheckPoint.title,
        'description': newCheckPoint.description,
        'created_at': newCheckPoint.createdAt.toIso8601String(),
        'session_id': newCheckPoint.sessionId
      });

      return id;
    } catch (error) {
      throw Exception("Failed to insert check point: $error");
    }
  }

  Future<void> deleteCheckPoint(int checkpointId) async {
    final db = await _databaseService.database;

    try {
      db.delete("check_points", where: 'id = ?', whereArgs: [checkpointId]);
    } catch (error) {
      throw Exception("Failed to delete check point: $error");
    }
  }

  Future<dynamic> updateCheckPoint(EditCheckPoint editCheckPoint) async {
    final db = await _databaseService.database;
    try {
      await db.update(
        "check_points",
        {'title': editCheckPoint.title, 'description': editCheckPoint.description},
        where: 'id = ?',
        whereArgs: [editCheckPoint.id]
      );

      return editCheckPoint;
    } catch (error) {
      throw Exception("Failed to update check point: $error");
    }
  }
}
