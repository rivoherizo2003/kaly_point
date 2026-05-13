import 'package:kaly_point/dto/edit_person_dto.dart';
import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/models/session_person.dart';
import 'package:kaly_point/services/abstract_service.dart';

class SessionPersonService extends AbstractService {
  Future<SessionPerson> assignPersonToSession(
    NewSessionPersonDto newSessionPerson,
  ) async {
    try {
      final db = await databaseService.database;
      final idSessionPerson = await db.insert("session_person", {
        'session_id': newSessionPerson.sessionId,
        'person_id': newSessionPerson.personId,
        'created_at': newSessionPerson.createdAt.toIso8601String(),
      });

      return SessionPerson(
        id: idSessionPerson,
        personId: newSessionPerson.personId,
        sessionId: newSessionPerson.sessionId,
        createdAt: newSessionPerson.createdAt,
      );
    } catch (error) {
      throw Exception("Failed to insert person in session: $error");
    }
  }

  Future<void> deletePerson({required int personId}) async {
    try {
      final db = await databaseService.database;
      await db.delete("person", where: 'id = ?', whereArgs: [personId]);
    } catch (error) {
      throw Exception("Failed to delete person:$error");
    }
  }

  Future<EditPersonDto> updatePerson(EditPersonDto editPersonDto) async {
    try {
      final db =  await databaseService.database;
      await db.update("person", {
        'lastname':editPersonDto.lastname,
        'firstname':editPersonDto.firstname,
      },
      where: 'id = ?',
      whereArgs: [editPersonDto.id]);

      return editPersonDto;
    } catch (error) {
      throw Exception("Failed to update person: $error");
    }
  }
}
