import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/dto/search_person_dto.dart';
import 'package:kaly_point/models/person.dart';
import 'package:kaly_point/services/abstract_service.dart';

class PersonService extends AbstractService {
  PersonService() {
    initDB();
  }

  Future<Person> insertPerson(NewPersonDto newPerson) async {
    try {
      final id = await db.insert('person', {
        'lastname': newPerson.lastname,
        'firstname': newPerson.firstname,
        'created_at': newPerson.createdAt.toIso8601String(),
      });

      return Person(
        id: id,
        lastname: newPerson.lastname,
        firstname: newPerson.firstname,
        createdAt: newPerson.createdAt,
      );
    } catch (error) {
      throw Exception("Failed to insert person: $error");
    }
  }

  Future<Person> findOneById(int personId) async {
    try {
      final List<Map<String, dynamic>> person = await db.query(
        "person",
        where: "id = ?",
        whereArgs: [personId],
        limit: 1,
      );
      return Person.fromMap(person.first);
    } catch (error) {
      throw Exception("Failed to retrieve a person: $error");
    }
  }

  Future<List<SearchPersonDto>> searchPerson(String query) async {
    final searchResults = await db.rawQuery("SELECT p.id AS person_id, p.lastname ,p.firstname, sp.session_id, cpp.check_point_id, cpp.id AS check_point_person_id  FROM person p LEFT JOIN session_person sp ON sp.person_id  = p.id LEFT JOIN check_point_person cpp ON cpp.person_id = p.id WHERE ((p.lastname LIKE \"%?%\" AND p.firstname LIKE \"%?%\") OR (p.firstname LIKE \"%?%\" AND p.lastname LIKE \"%?%\")) AND (p.id = ?) ORDER BY p.lastname ASC");
    return searchResults
        .map((person) => SearchPersonDto.fromMap(person))
        .toList();
  }
}
