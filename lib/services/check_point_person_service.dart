import 'package:flutter/material.dart';
import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/dto/person_session_dto.dart';
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

  Future<dynamic> fetchToServePersons({required int sessionId, required int page, required int limit}) async {
    initDB();
    debugPrint("fetchToServePersons $sessionId");
    try {

      //TODO fix this query in order to list person who are in the session but not in the active check point
      final toServePersons = await db.rawQuery('SELECT p.id AS person_id, p.lastname ,p.firstname, sp.session_id FROM session_person sp JOIN person p ON p.id = sp.person_id JOIN sessions s ON s.id = sp.session_id  WHERE s.id = ? ORDER BY p.lastname ASC;', [sessionId]);
      debugPrint("test ${toServePersons.length}");
      return toServePersons.map((checkPointPerson) => CheckPointPersonService().fromMap(checkPointPerson));
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  PersonSessionDto fromMap(Map<String, dynamic> map){
    return PersonSessionDto(personId: map['person_id'], sessionId: map['session_id'], lastname: map['lastname'], firstname: map['firstname']);
  }


  Future<dynamic> fetchServedPersons({required int checkPointId, required int page, required int limit}) async {
    initDB();
    debugPrint("fetchToServePersons $checkPointId");
    try {

      //TODO fix this query in order to list person who are in the session and in the active check point
      final servedPersons = await db.rawQuery('SELECT cpp.id AS check_point_person_id, cpp.check_point_id, cpp.person_id, p.firstname ,p.lastname FROM check_point_person cpp JOIN person p ON p.id = cpp.person_id JOIN check_points cp ON cp.id = cpp.check_point_id  WHERE cpp.check_point_id = ? ORDER BY p.lastname ASC;', [checkPointId]);
      debugPrint("served persons ${servedPersons.length}");
      
      return servedPersons.map((checkPointPerson) => PersonCheckPointDto.fromMap(checkPointPerson));
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }
}