import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
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
    try {
      final toServePersons = await db.rawQuery('SELECT cpp.id, cpp.check_point_id, cpp.person_id, p.lastname ,p.firstname  FROM check_point_person cpp JOIN person p ON p.id = cpp.person_id JOIN session s ON s.id = cpp.session_id WHERE cpp.check_point_id = ?;');
      
      return toServePersons.map((checkPointPerson) => CheckPointPersonService().fromMap(checkPointPerson));
    } catch (error) {
      throw Exception("Failed to fetch person from check_point_person: $error");
    }
  }

  PersonCheckPointDto fromMap(Map<String, dynamic> map){
    return PersonCheckPointDto(personId: map['person_id'], sessionId: map['session_id'], checkPointId: map['check_point_id'], lastname: map['lastname'], firstname: map['firstname'], id: map['id']);
  }
}