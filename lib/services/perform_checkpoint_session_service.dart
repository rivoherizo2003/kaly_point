import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/services/abstract_service.dart';
import 'package:sqflite/sqflite.dart';

class PerformCheckpointSessionService extends AbstractService {
  Future<int> countPersonInSession({required int sessionId}) async {
    final db = await databaseService.database;
    final nbrPersonInSession = await db.rawQuery(
      'SELECT COUNT(*) FROM session_person WHERE session_id = ?',
      [sessionId],
    );

    return Sqflite.firstIntValue(nbrPersonInSession) ?? 0;
  }

  Future<int> countServedPersonCheckPoint({
    required int sessionId,
    required int checkPointId,
  }) async {
    final db = await databaseService.database;

    final nbrServedPersons = db.rawQuery(
      'SELECT COUNT(*) FROM check_point_person WHERE check_point_id = ?',
      [checkPointId],
    );

    return Sqflite.firstIntValue(await nbrServedPersons) ?? 0;
  }

  Future<List<PersonCheckPointDto>> searchPerson(String query) async {
    final db = await databaseService.database;
    final searchResults = await db.rawQuery("SELECT * FROM persons");
    return searchResults
        .map((result) => PersonCheckPointDto.fromMap(result))
        .toList();
  }
}
