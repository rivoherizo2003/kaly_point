import 'package:kaly_point/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PerformCheckpointSessionService {
  final _databaseService = DatabaseService();

  Future<int> countPersonInSession({required int sessionId}) async {
    final db = await _databaseService.database;
    final nbrPersonInSession = db.rawQuery('SELECT COUNT(*) FROM session_person WHERE session_id = ?',[sessionId]);

    return Sqflite.firstIntValue(await nbrPersonInSession) ?? 0;
  }

  Future<int> countServedPersonCheckPoint({required int sessionId, required int checkPointId}) async {
    final db = await _databaseService.database;
    final nbrServedPersons = db.rawQuery('SELECT COUNT(*) FROM check_point_person WHERE check_point_id = ?', [checkPointId]);

    return Sqflite.firstIntValue(await nbrServedPersons) ?? 0;
  }
  
}