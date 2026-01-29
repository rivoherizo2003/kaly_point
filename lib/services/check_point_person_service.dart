import 'package:flutter/material.dart';
import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/dto/person_to_serve_dto.dart';
import 'package:kaly_point/models/person_check_point.dart';
import 'package:kaly_point/services/abstract_service.dart';

class CheckPointPersonService extends AbstractService {
  CheckPointPersonService(){
    initDB();
  }

  Future<PersonCheckPoint> createPersonCheckPoint(NewPersonCheckPointDto newPersonCheckPoint) async {
    try {
      final idCheckPointPerson = await db.insert("check_point_person", {
        'check_point_id': newPersonCheckPoint.checkPointId,
        'person_id': newPersonCheckPoint.personId,
        'created_at': newPersonCheckPoint.createdAt.toIso8601String()
      });

      return PersonCheckPoint(id: idCheckPointPerson, personId: newPersonCheckPoint.personId, sessionId: newPersonCheckPoint.sessionId, createdAt: newPersonCheckPoint.createdAt, checkPointId: newPersonCheckPoint.checkPointId);
    } catch (error) {
      throw Exception("Failed to insert person in check_point: $error");
    }
  }

  Future<dynamic> fetchToServePersons({required int checkPointId, required int page, required int limit}) async {
    initDB();
    debugPrint("fetchToServePersons $checkPointId");
    try {

      //TODO fix this query in order to list person who are in the session but not in the active check point
      final toServePersons = await db.rawQuery('SELECT p.id AS person_id, p.lastname, p.firstname, s.title AS session_title, target_cp.id AS check_point_id FROM check_points target_cp JOIN sessions s ON target_cp.session_id = s.id JOIN session_person sp ON s.id = sp.session_id JOIN person p ON sp.person_id = p.id WHERE target_cp.id = ? AND NOT EXISTS (SELECT 1 FROM check_point_person cpp WHERE cpp.check_point_id = target_cp.id AND cpp.person_id = p.id) ORDER BY p.lastname ASC', [checkPointId]);
      debugPrint("test ${toServePersons.length}");
      return toServePersons.map((checkPointPerson) => CheckPointPersonService().fromMap(checkPointPerson));
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  PersonToServeDto fromMap(Map<String, dynamic> map){
    return PersonToServeDto(personId: map['person_id'], lastname: map['lastname'], firstname: map['firstname'], checkPointId: map['check_point_id']);
  }


  Future<dynamic> fetchServedPersons({required int checkPointId, required int page, required int limit}) async {
    initDB();
    debugPrint("fetchToServePersons $checkPointId");
    try {

      //TODO fix this query in order to list person who are in the session and in the active check point
      final servedPersons = await db.rawQuery('SELECT p.id AS person_id, p.lastname ,p.firstname,cpp.check_point_id, cpp.id AS check_point_person_id FROM person p JOIN check_point_person cpp ON cpp.person_id  = p.id WHERE cpp.check_point_id  = ? ORDER BY p.lastname ASC', [checkPointId]);
      debugPrint("served persons ${servedPersons.length}");
      
      return servedPersons.map((checkPointPerson) => PersonCheckPointDto.fromMap(checkPointPerson));
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  Future<void> deleteCheckPointPerson({required int checkPointPersonId}) async {
    try {
      db.delete("check_point_person", where: 'id = ?', whereArgs: [checkPointPersonId]);
    } catch (error) {
      throw Exception("Failed to delete check_point_person: $error");
    }
  }
}