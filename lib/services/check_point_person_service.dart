import 'package:flutter/rendering.dart';
import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/person_check_point.dart';
import 'package:kaly_point/services/abstract_service.dart';
import 'package:sqflite/sqflite.dart';

class CheckPointPersonService extends AbstractService {
  Future<PersonCheckPoint> createPersonCheckPoint(
    NewPersonCheckPointDto newPersonCheckPoint,
  ) async {
    try {
      final db = await databaseService.database;
      final idCheckPointPerson = await db.insert("check_point_person", {
        'check_point_id': newPersonCheckPoint.checkPointId,
        'person_id': newPersonCheckPoint.personId,
        'created_at': newPersonCheckPoint.createdAt.toIso8601String(),
      });

      return PersonCheckPoint(
        id: idCheckPointPerson,
        personId: newPersonCheckPoint.personId,
        sessionId: newPersonCheckPoint.sessionId,
        createdAt: newPersonCheckPoint.createdAt,
        checkPointId: newPersonCheckPoint.checkPointId,
      );
    } catch (error) {
      throw Exception("Failed to insert person in check_point: $error");
    }
  }

  Future<dynamic> fetchToServePersons({
    required int checkPointId,
    required int limit,
    required int offset,
  }) async {
    try {
      debugPrint("fetchToServePersons limit $limit offset $offset");
      final db = await databaseService.database;
      final String q = '''
        SELECT 
          p.id AS person_id,
          p.lastname,p.firstname, 
          sp.id AS session_person_id, 
          check_points.session_id as current_session_id, 
          (SELECT id FROM check_point_person cpp2 WHERE cpp2.check_point_id  = ?2 AND cpp2.person_id = p.id) AS check_point_person_id 
          FROM check_points check_points 
          JOIN sessions s ON check_points.session_id = s.id 
          JOIN session_person sp ON s.id = sp.session_id 
          JOIN person p ON sp.person_id = p.id 
          WHERE check_points.id = ?3 AND 
          NOT EXISTS (
            SELECT 1 FROM check_point_person cpp 
            WHERE cpp.check_point_id = check_points.id AND
            cpp.person_id = p.id) 
            ORDER BY p.lastname COLLATE NOCASE,p.firstname COLLATE NOCASE LIMIT ?4 OFFSET ?5
        ''';

      final toServePersons = await db.rawQuery(q, [
        checkPointId,
        checkPointId,
        checkPointId,
        limit,
        offset,
      ]);
      debugPrint("fetchToServePersons toServePersons ${toServePersons.length}");
      return toServePersons.map(
        (checkPointPerson) => PersonCheckPointDto.fromMap(checkPointPerson),
      );
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  PersonCheckPointDto fromMap(Map<String, dynamic> map) {
    return PersonCheckPointDto(
      personId: map['person_id'],
      lastname: map['lastname'],
      firstname: map['firstname'],
      checkPointId: map['check_point_id'],
      currentSessionId: map['session_id'],
    );
  }

  Future<dynamic> fetchServedPersons({
    required int checkPointId,
    required int limit,
    required int offset,
  }) async {
    try {
      final db = await databaseService.database;
      final servedPersons = await db.rawQuery(
        '''
          SELECT 
            p.id AS person_id, 
            p.lastname ,
            p.firstname,
            cpp.check_point_id,
            cpp.id AS check_point_person_id,
            (SELECT cp.session_id  FROM check_points cp WHERE cp.id = ?1 LIMIT 1) as current_session_id
            FROM person p 
            JOIN check_point_person cpp ON cpp.person_id  = p.id 
            WHERE cpp.check_point_id  = ?1 
            ORDER BY p.lastname COLLATE NOCASE,p.firstname COLLATE NOCASE LIMIT ?2 OFFSET ?3
        ''',
        [checkPointId, limit, offset],
      );

      return servedPersons.map(
        (checkPointPerson) => PersonCheckPointDto.fromMap(checkPointPerson),
      );
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  Future<void> deleteCheckPointPerson({required int checkPointPersonId}) async {
    try {
      final db = await databaseService.database;
      db.delete(
        "check_point_person",
        where: 'id = ?',
        whereArgs: [checkPointPersonId],
      );
    } catch (error) {
      throw Exception("Failed to delete check_point_person: $error");
    }
  }

  Future<void> deleteByCheckPointPersonId({
    required int checkPointPersonId,
    DatabaseExecutor? executor
  }) async {
    try {
      final db = executor ?? await databaseService.database;

      await db.delete(
        "check_point_person",
        where: 'id = ?',
        whereArgs: [checkPointPersonId],
      );
    } catch (e) {
      debugPrint("erreur $e");
      throw Exception("SessionPersonService[deleteByPersonIdCheckPointId]: Failed to delete check_point_person: $e");
    }
  }
}
