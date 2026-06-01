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

  Future<List<PersonCheckPointDto>> searchPerson(
    String params,
    int indexActiveTab,
    int checkPointId,
    int currentSessionId,
  ) async {
    final db = await databaseService.database;
    final List<String> paramsSplit = params.trim().split("-");
    List<Object?> whereParams = [];

    String query = """
          SELECT
            p.id AS person_id,
            p.lastname,
            p.firstname,
            sp1.id AS session_person_id,
            cpp.id AS check_point_person_id,
            (SELECT s.id  FROM sessions s WHERE s.id = ?) as current_session_id,
            (SELECT sp2.id FROM session_person sp2 WHERE sp2.person_id = p.id AND sp2.session_id = ?) AS session_person_id,
            (SELECT id FROM check_point_person cpp2 WHERE cpp2.check_point_id  = ? AND cpp2.person_id = p.id) AS check_point_person_id
          FROM person p 
          LEFT JOIN session_person sp1 ON sp1.person_id = p.id 
          LEFT JOIN check_point_person cpp ON cpp.person_id = p.id
        """;

    String? whereQuery = "";
    whereParams.add(currentSessionId);
    whereParams.add(currentSessionId);
    whereParams.add(checkPointId);

    if (paramsSplit.elementAtOrNull(0) != null &&
        int.tryParse(paramsSplit.elementAt(0)) != null) {
      whereQuery += " p.id = ?";
      whereParams.add(paramsSplit.elementAt(0));

      if (paramsSplit.elementAtOrNull(1) != null &&
          paramsSplit.elementAtOrNull(2) == null &&
          paramsSplit.elementAt(1).isNotEmpty) {
        whereQuery += whereQuery.isNotEmpty ? " AND " : " ";
        whereQuery += "(p.lastname LIKE ? OR p.firstname LIKE ?)";
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));
      }

      if (paramsSplit.elementAtOrNull(1) != null &&
          paramsSplit.elementAtOrNull(2) != null &&
          paramsSplit.elementAt(1).isNotEmpty &&
          paramsSplit.elementAt(2).isNotEmpty) {
        whereQuery += whereQuery.isNotEmpty ? " AND " : " ";
        whereQuery +=
            " ((p.lastname LIKE ? AND p.firstname LIKE ?) OR (p.firstname LIKE ? AND p.lastname LIKE ?))  ";
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(2)));

        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(2)));
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));
      }
    } else {
      if (paramsSplit.elementAtOrNull(0) != null &&
          paramsSplit.elementAtOrNull(1) == null) {
        whereQuery += " p.lastname LIKE ?";
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(0)));
      } else {
        whereQuery += whereQuery.isNotEmpty ? " AND " : " ";
        whereQuery +=
            " ((p.lastname LIKE ? AND p.firstname LIKE ?) OR (p.firstname LIKE ? AND p.lastname LIKE ?))  ";
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(0)));
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));

        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(0)));
        whereParams.add(formatParameterForLikeSearch(paramsSplit.elementAt(1)));
      }
    }

    if (indexActiveTab == 1) {
      whereQuery += " AND cpp.check_point_id = ?";
      whereParams.add(checkPointId);
    }

    if (whereQuery.isNotEmpty) {
      query += " WHERE $whereQuery";
    }

    query += " GROUP BY p.id ORDER BY p.lastname, p.firstname COLLATE NOCASE ASC";

    final searchResults = await db.rawQuery(query, whereParams);
    return searchResults
        .map((result) => PersonCheckPointDto.fromMap(result))
        .toList();
  }

  String formatParameterForLikeSearch(String param) {
    return "%$param%";
  }
}
