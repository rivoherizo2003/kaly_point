import 'package:flutter/rendering.dart';
import 'package:kaly_point/dto/edit_person_dto.dart';
import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/models/session_person.dart';
import 'package:kaly_point/services/abstract_service.dart';
import 'package:kaly_point/services/check_point_person_service.dart';
import 'package:sqflite/sqlite_api.dart';

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
      throw Exception(
        "SessionPersonService[assignPersonToSession]: Failed to insert person in session: $error",
      );
    }
  }

  Future<bool> isThisPersonIdRegisteredInAnotherSession({
    required int personId,
    required int currentSessionId,
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await databaseService.database;
      final List<Map<String, dynamic>> sessionPerson = await db.query(
        "session_person",
        where: "person_id = ? AND session_id <> ?",
        whereArgs: [personId, currentSessionId],
        limit: 1,
      );

      return sessionPerson.isNotEmpty;
    } catch (error) {
      throw Exception(
        "SessionPersonService[findOneByPersonIdAndNotInCurrentSession]: Failed to retrieve a person: $error",
      );
    }
  }

  Future<void> deletePerson({
    required int personId,
    int? currentSessionId,
    int? currentCheckPointId,
  }) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      bool isPersonIdResgisteredInOtherSession = false;

      if (currentSessionId != null) {
        isPersonIdResgisteredInOtherSession =
            await isThisPersonIdRegisteredInAnotherSession(
              personId: personId,
              currentSessionId: currentSessionId,
              executor: txn,
            );
      }

      debugPrint("=> $isPersonIdResgisteredInOtherSession");

      if (!isPersonIdResgisteredInOtherSession) {
        //Delete the person in the current checkpoint
        await removePersonFromCheckPointAndSession(
          currentCheckPointId,
          personId,
          currentSessionId,
          txn,
        );

        try {
          await txn.delete("person", where: 'id = ?', whereArgs: [personId]);

          return;
        } catch (error) {
          debugPrint("$error");
          throw Exception(
            "SessionPersonService[deletePerson]: Failed to delete person:$error",
          );
        }
      }
    });

    db.transaction((txn) async {
      await removePersonFromCheckPointAndSession(
        currentCheckPointId,
        personId,
        currentSessionId,
        txn,
      );
    });
  }

  Future<void> removePersonFromCheckPointAndSession(
    int? currentCheckPointPersonId,
    int personId,
    int? currentSessionId,
    DatabaseExecutor? executor,
  ) async {
    //Delete the person in the current checkpoint
    try {
      debugPrint("ici $currentCheckPointPersonId $currentSessionId");
      if (currentCheckPointPersonId != null) {
        checkPointPersonService.deleteByCheckPointPersonId(
          checkPointPersonId: currentCheckPointPersonId,
          executor: executor,
        );
      }

      //Delete the person in the session_person with the current session ID
      if (currentSessionId != null) {
        await deleteByPersonIdAndSessionId(
          personId: personId,
          currentSessionId: currentSessionId,
          executor: executor,
        );
      }
    } catch (e) {
      debugPrint("$e");
      throw Exception(
        "SessionPersonService[removePersonFromCheckPointAndSession]: Failed to remove person from checkpoint and session: $e",
      );
    }
  }

  Future<void> deleteByPersonIdAndSessionId({
    required int personId,
    required int currentSessionId,
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await databaseService.database;
      await db.delete(
        "session_person",
        where: 'person_id = ? AND session_id = ?',
        whereArgs: [personId, currentSessionId],
      );
    } catch (e) {
      debugPrint("$e");
      throw Exception(
        "SessionPersonService[deleteByPersonIdAndSessionId]: Failed to delete session_person: $e",
      );
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
      throw Exception(
        "SessionPersonService[updatePerson]: Failed to update person: $error",
      );
    }
  }
}
