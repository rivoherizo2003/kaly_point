import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/models/person.dart';
import 'package:kaly_point/services/abstract_service.dart';

class PersonService extends AbstractService{
  PersonService(){
    initDB();
  }
  
  Future<Person> insertPerson(NewPersonDto newPerson) async {
    try {
      final id = await db.insert('person', {
        'lastname': newPerson.lastname,
        'firstname':newPerson.firstname,
        'created_at': newPerson.createdAt.toIso8601String(),
      });

      return Person(id: id, lastname: newPerson.lastname,firstname: newPerson.firstname, createdAt: newPerson.createdAt);
    } catch (error) {
      throw Exception("Failed to insert person: $error");
    }
  }

  Future<Person> findOneById(int personId) async {
    try {
      final List<Map<String, dynamic>> person = await db.query("person", 
      where: "id = ?",
      whereArgs: [personId],
      limit: 1); 
      return Person.fromMap(person.first);
    } catch (error) {
      throw Exception("Failed to retrieve a person: $error");
    }
  }
}