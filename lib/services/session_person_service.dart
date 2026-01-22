import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/models/session_person.dart';
import 'package:kaly_point/services/abstract_service.dart';

class SessionPersonService extends AbstractService {
  SessionPersonService(){
    initDB();
  }

  Future<SessionPerson> assignPersonToSession(NewSessionPersonDto newSessionPerson) async {
    try {
      final idSessionPerson = await db.insert("session_person", {
        'session_id': newSessionPerson.sessionId,
        'person_id': newSessionPerson.personId,
        'created_at': newSessionPerson.createdAt.toIso8601String()
      });

      return SessionPerson(id: idSessionPerson, personId: newSessionPerson.personId, sessionId: newSessionPerson.sessionId, createdAt: newSessionPerson.createdAt);
    } catch (error) {
      throw Exception("Failed to insert person in session: $error");
    }
  }
}