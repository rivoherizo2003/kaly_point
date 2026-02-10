import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/dto/edit_check_point_dto.dart';
import 'package:kaly_point/dto/new_check_point_dto.dart';
import 'package:kaly_point/services/abstract_service.dart';

class CheckpointService extends AbstractService {
  Future<dynamic> getCheckPoints({
    required int page,
    required int limit,
    required int sessionId,
  }) async {
    final int offset = (page - 1) * limit;
    final db = await databaseService.database;

    final results = await db
        .query(
          "check_points",
          limit: limit,
          offset: offset,
          orderBy: "created_at DESC",
          where: 'session_id = ?',
          whereArgs: [sessionId],
        )
        .onError((error, stackTrace) {
          throw Exception('Failed to fetch check points: $error');
        });

    return results.map((checkpoint) => CheckPoint.fromMap(checkpoint));
  }

  Future<int> insertNewCheckPoint(NewCheckPointDto newCheckPoint) async {
    try {
      final db = await databaseService.database;

      final id = await db.insert("check_points", {
        'title': newCheckPoint.title,
        'description': newCheckPoint.description,
        'created_at': newCheckPoint.createdAt.toIso8601String(),
        'session_id': newCheckPoint.sessionId,
      });

      return id;
    } catch (error) {
      throw Exception("Failed to insert check point: $error");
    }
  }

  Future<void> deleteCheckPoint(int checkpointId) async {
    try {
      final db = await databaseService.database;

      db.delete("check_points", where: 'id = ?', whereArgs: [checkpointId]);
    } catch (error) {
      throw Exception("Failed to delete check point: $error");
    }
  }

  Future<dynamic> updateCheckPoint(EditCheckPointDto editCheckPoint) async {
    try {
      final db = await databaseService.database;

      await db.update(
        "check_points",
        {
          'title': editCheckPoint.title,
          'description': editCheckPoint.description,
        },
        where: 'id = ?',
        whereArgs: [editCheckPoint.id],
      );

      return editCheckPoint;
    } catch (error) {
      throw Exception("Failed to update check point: $error");
    }
  }
}
