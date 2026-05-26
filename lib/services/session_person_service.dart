import 'package:flutter/rendering.dart';
import 'package:kaly_point/dto/edit_person_dto.dart';
import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/models/session_person.dart';
import 'package:kaly_point/services/abstract_service.dart';
import 'package:kaly_point/services/check_point_person_service.dart';

class SessionPersonService extends AbstractService {
  final CheckPointPersonService checkPointPersonService =
      CheckPointPersonService();

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

  Future<SessionPerson?> findOneByPersonIdAndNotInCurrentSession({
    required int personId,
    required int currentSessionId,
  }) async {
    try {
      final db = await databaseService.database;
      final List<Map<String, dynamic>> sessionPerson = await db.query(
        "session_person",
        where: "person_id = ? AND session_id <> ?",
        whereArgs: [personId, currentSessionId],
        limit: 1,
      );

      if (sessionPerson.isEmpty) {
        return null;
      }

      return SessionPerson.fromMap(sessionPerson.first);
    } catch (error) {
      throw Exception("Failed to retrieve a person: $error");
    }
  }

  Future<void> deletePerson({
    required int personId,
    int? currentSessionId,
    int? currentCheckPointId,
  }) async {
    SessionPerson? sessionPerson;

    if (currentSessionId != null) {
      sessionPerson = await findOneByPersonIdAndNotInCurrentSession(
        personId: personId,
        currentSessionId: currentSessionId,
      );
    }

    if (sessionPerson == null) {
      //Delete the person in the current checkpoint
      await removePersonFromCheckPointAndSession(
        currentCheckPointId,
        personId,
        currentSessionId,
      );

      try {
        //Delete the person
        final db = await databaseService.database;

        await db.delete("person", where: 'id = ?', whereArgs: [personId]);

        return;
      } catch (error) {
        debugPrint("$error");
        throw Exception("Failed to delete person:$error");
      }
    }

    await removePersonFromCheckPointAndSession(
      currentCheckPointId,
      personId,
      currentSessionId,
    );
  }

  Future<void> removePersonFromCheckPointAndSession(
    int? currentCheckPointId,
    int personId,
    int? currentSessionId,
  ) async {
    //Delete the person in the current checkpoint
    try {
      if (currentCheckPointId != null) {
        checkPointPersonService.deleteByPersonIdCheckPointId(
          personId: personId,
          checkPointId: currentCheckPointId,
        );
      }

      //Delete the person in the session_person with the current session ID
      if (currentSessionId != null) {
        await deleteByPersonIdAndSessionId(
          personId: personId,
          currentSessionId: currentSessionId,
        );
      }
    } catch (e) {
      debugPrint("$e");

      throw Exception(
        "Failed to remove person from checkpoint and session: $e",
      );
    }
  }

  Future<void> deleteByPersonIdAndSessionId({
    required int personId,
    required int currentSessionId,
  }) async {
    try {
      await db.delete(
        "session_person",
        where: 'person_id = ? AND session_id = ?',
        whereArgs: [personId, currentSessionId],
      );
    } catch (e) {
      debugPrint("$e");
      throw Exception("Failed to delete session_person: $e");
    }
  }

  Future<EditPersonDto> updatePerson(EditPersonDto editPersonDto) async {
    try {
      final db = await databaseService.database;
      await db.update(
        "person",
        {
          'lastname': editPersonDto.lastname,
          'firstname': editPersonDto.firstname,
        },
        where: 'id = ?',
        whereArgs: [editPersonDto.id],
      );

      return editPersonDto;
    } catch (error) {
      throw Exception("Failed to update person: $error");
    }
  }
}
